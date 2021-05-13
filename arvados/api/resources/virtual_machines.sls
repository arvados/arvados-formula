# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_config_file = tplroot ~ '.config.file' %}
{%- from tplroot ~ "/map.jinja" import arvados with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

{%- set virtual_machines = arvados.cluster.resources.virtual_machines | default({}) %}
{%- set api_token = arvados.cluster.tokens.system_root | yaml_encode %}
{%- set api_host = arvados.cluster.Services.Controller.ExternalURL | regex_replace('^http(s?)://', '', ignorecase=true) %}

include:
  - ..package
  - {{ sls_config_file }}
  - ..service

arvados-api-resources-virtual-machines-jq-pkg-installed:
  pkg.installed:
    - name: jq

{%- for vm, vm_params in virtual_machines.items() %}
  {%- set vm_name = vm_params.name | default(vm) %}

  {%- set cmd_query_vm_uuid = 'ARVADOS_API_TOKEN=' ~ api_token ~
                              ' ARVADOS_API_HOST=' ~ api_host ~
                              ' arv --short virtual_machine list' ~
                              ' --filters \'[["hostname", "=", "' ~ vm_name ~ '"]]\''
  %}

# Create the virtual machine record
arvados-api-resources-virtual-machines-{{ vm }}-record-cmd-run:
  cmd.run:
    - env:
      - ARVADOS_API_TOKEN: {{ api_token }}
      - ARVADOS_API_HOST: {{ api_host }}
    - name: |
        arv --format=uuid \
          virtual_machine \
          create \
          --virtual-machine '{"hostname":"{{ vm_name }}" }'
    - unless: |
          {{ cmd_query_vm_uuid }} | \
          /bin/grep -qE "fixme-2x53u-[a-z0-9]{15}"

  # As we need the UUID generated in the previous command, we need to
  # iterate again in order to get them
  {% set vm_uuid = salt['cmd.shell'](cmd_query_vm_uuid) %}

  {%- set scoped_token_url = '/arvados/v1/virtual_machines/' ~ vm_uuid ~ '/logins' %}

  # There's no direct way to query the scoped_token for a given virtual_machine
  # so we need to parse the api_client_authorization list through some jq
  {%- set cmd_query_scoped_token_url = 'ARVADOS_API_TOKEN=' ~ api_token ~
                                       ' ARVADOS_API_HOST=' ~ api_host ~
                                       ' arv api_client_authorization list |' ~
                                       ' jq -e \'.items[].scopes[] | select(. == "GET ' ~
                                       scoped_token_url ~ '")\''
  %}
# Create the VM scoped tokens
arvados-api-resources-virtual-machines-{{ vm }}-scoped-token-cmd-run:
  cmd.run:
    - env:
      - ARVADOS_API_TOKEN: {{ api_token }}
      - ARVADOS_API_HOST: {{ api_host }}
    - name: |
        arv --format=uuid \
          api_client_authorization \
          create \
          --api-client-authorization '{"scopes":["GET {{ scoped_token_url }}"]}'
    - require:
      - pkg: arvados-api-resources-virtual-machines-jq-pkg-installed
    - unless: {{ cmd_query_scoped_token_url }}

{%- endfor %}

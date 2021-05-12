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

{%- for vm, vm_params in virtual_machines.items() %}
  {%- set vm_name = vm_params.name | default(vm) %}
  {%- set vm_backend = vm_params.backend | default(vm_name) %}
  {%- set vm_port = vm_params.port | default(4200) %}

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
    - onlyif: |
        ARVADOS_API_TOKEN={{ api_token }} \
        ARVADOS_API_HOST={{ api_host }} \
        arv --short \
          virtual_machine \
          list \
          --filters '[["hostname", "=", "{{ vm_name }}"]]' | \
          /bin/grep -qE "fixme-2x53u-[a-z0-9_]{15}" && \
          false
{%- endfor %}

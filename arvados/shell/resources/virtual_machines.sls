# -*- coding: utf-8 -*-
# vim: ft=sls

# Copyright (C) The Arvados Authors. All rights reserved.
#
# SPDX-License-Identifier: Apache-2.0

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{#- set sls_config_file = tplroot ~ '.config.file' #}
{%- from tplroot ~ "/map.jinja" import arvados with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

{%- set virtual_machines = arvados.cluster.resources.virtual_machines | default({}) %}
{%- set api_token = arvados.cluster.tokens.system_root | yaml_encode %}
{%- set api_host = arvados.cluster.Services.Controller.ExternalURL | regex_replace('^http(s?)://', '', ignorecase=true) %}

include:
  - ..package
  {# - {{ sls_config_file }} #}
  # - ..service

arvados-shell-resources-virtual-machines-jq-pkg-installed:
  pkg.installed:
    - name: jq

{%- for vm, vm_params in virtual_machines.items() %}
  {%- set vm_name = vm_params.name | default(vm) %}
  {%- set arvados_api_host_insecure = arvados.cluster.tls.insecure | default(false) %}

  {%- set cmd_query_vm_uuid = 'ARVADOS_API_TOKEN=' ~ api_token ~ ' ' ~
                              'ARVADOS_API_HOST=' ~ api_host ~ ' ' ~
                              'ARVADOS_API_HOST_INSECURE=' ~ arvados_api_host_insecure ~
                              ' arv --short virtual_machine list' ~
                              ' --filters \'[["hostname", "=", "' ~ vm_name ~ '"]]\''
  %}

# Create the virtual machine record
arvados-shell-resources-virtual-machines-{{ vm }}-record-cmd-run:
  cmd.run:
    - env:
      - ARVADOS_API_TOKEN: {{ api_token }}
      - ARVADOS_API_HOST: {{ api_host }}
      - ARVADOS_API_HOST_INSECURE: {{ arvados.cluster.tls.insecure | default(false) }}
    - name: |
        arv --format=uuid \
          virtual_machine \
          create \
          --virtual-machine '{"hostname":"{{ vm_name }}" }'
    - unless: |
          {{ cmd_query_vm_uuid }} | \
          /bin/grep -qE "[a-z0-9]{5}-2x53u-[a-z0-9]{15}"
    - require:
      - pkg: arvados-shell-package-install-pkg-installed
      - gem: arvados-shell-package-install-gem-arvados-cli-installed

# We need to use the UUID generated in the previous command to see if there's a
# scoped token for it. There's no easy way to pass the value from a shellout
# to another state, so we store it in a temp file and use that in the next
# command. Flaky, mostly because the `unless` clause is just checking thatg
# the file content is a token uuid :|
arvados-shell-resources-virtual-machines-{{ vm }}-get-vm_uuid-cmd-run:
  cmd.run:
    - name: {{ cmd_query_vm_uuid }} | head -1 | tee /tmp/{{ vm }}
    - require:
      - cmd: arvados-shell-resources-virtual-machines-{{ vm }}-record-cmd-run
      - gem: arvados-shell-package-install-gem-arvados-cli-installed
    - unless:
      - /bin/grep -qE "[a-z0-9]{5}-2x53u-[a-z0-9]{15}" /tmp/{{ vm }}

  # There's no direct way to query the scoped_token for a given virtual_machine
  # so we need to parse the api_client_authorization list through some jq
  {%- set cmd_query_scoped_token_url = 'VM_UUID=$(cat /tmp/' ~ vm ~ ') && ' ~
                                       'ARVADOS_API_TOKEN=' ~ api_token ~ ' ' ~
                                       'ARVADOS_API_HOST=' ~ api_host ~ ' ' ~
                                       'ARVADOS_API_HOST_INSECURE=' ~ arvados_api_host_insecure ~
                                       ' arv api_client_authorization list |' ~
                                       ' /usr/bin/jq -e \'.items[].scopes[] | select(. == "GET ' ~
                                       '/arvados/v1/virtual_machines/\'${VM_UUID}\'/logins")\' && ' ~
                                       'unset VM_UUID'
  %}

# Create the VM scoped tokens
arvados-shell-resources-virtual-machines-{{ vm }}-scoped-token-cmd-run:
  cmd.run:
    - env:
      - ARVADOS_API_TOKEN: {{ api_token }}
      - ARVADOS_API_HOST: {{ api_host }}
      - ARVADOS_API_HOST_INSECURE: {{ arvados.cluster.tls.insecure | default(false) }}
    - name: |
        VM_UUID=$(cat /tmp/{{ vm }}) &&
        arv --format=uuid \
          api_client_authorization \
          create \
          --api-client-authorization '{"scopes":["GET /arvados/v1/virtual_machines/'${VM_UUID}'/logins"]}'
    - unless: {{ cmd_query_scoped_token_url }}
    - require:
      - pkg: arvados-shell-package-install-pkg-installed
      - pkg: arvados-shell-resources-virtual-machines-jq-pkg-installed
      - cmd: arvados-shell-resources-virtual-machines-{{ vm }}-get-vm_uuid-cmd-run
      - gem: arvados-shell-package-install-gem-arvados-cli-installed

{%- endfor %}

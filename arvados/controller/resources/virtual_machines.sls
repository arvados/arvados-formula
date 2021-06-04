# -*- coding: utf-8 -*-
# vim: ft=sls

# Copyright (C) The Arvados Authors. All rights reserved.
#
# SPDX-License-Identifier: Apache-2.0

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_config_file = tplroot ~ '.config.file' %}
{%- from tplroot ~ "/map.jinja" import arvados with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

{%- set virtual_machines = arvados.cluster.resources.virtual_machines | default({}) %}
{%- set api_token = arvados.cluster.tokens.system_root | yaml_encode %}
{%- set api_host = arvados.cluster.Services.Controller.ExternalURL | regex_replace('^http(s?)://', '', ignorecase=true) %}

{%- set arv_command = '/usr/local/rvm/bin/rvm-exec default arv'
                      if arvados.ruby.manage_ruby and arvados.ruby.use_rvm
                      else 'arv' %}
include:
  - ..package
  - {{ sls_config_file }}
  - ..service

arvados-controller-resources-virtual-machines-jq-pkg-installed:
  pkg.installed:
    - name: jq

{%- for vm, vm_params in virtual_machines.items() %}
  {%- set vm_name = vm_params.name | default(vm) %}

  {%- set cmd_query_vm_uuid = 'ARVADOS_API_TOKEN=' ~ api_token ~
                              ' ARVADOS_API_HOST=' ~ api_host ~ ' ' ~
                              arv_command ~ ' --short virtual_machine list' ~
                              ' --filters \'[["hostname", "=", "' ~ vm_name ~ '"]]\''
  %}

# Create the virtual machine record
arvados-controller-resources-virtual-machines-{{ vm }}-record-cmd-run:
  cmd.run:
    - env:
      - ARVADOS_API_TOKEN: {{ api_token }}
      - ARVADOS_API_HOST: {{ api_host }}
    - name: |
        {{ arv_command }} --format=uuid \
          virtual_machine \
          create \
          --virtual-machine '{"hostname":"{{ vm_name }}" }'
    - unless: |
          {{ cmd_query_vm_uuid }} | \
          /bin/grep -qE "[a-z0-9]{5}-2x53u-[a-z0-9]{15}"
    - require:
      - pkg: arvados-controller-package-install-pkg-installed
      - cmd: arvados-controller-service-running-service-ready-cmd-run
      - gem: arvados-controller-package-install-gem-arvados-cli-installed

# We need to use the UUID generated in the previous command to see if there's a
# scoped token for it. There's no easy way to pass the value from a shellout
# to another state, so we store it in a temp file and use that in the next
# command. Flaky, mostly because the `unless` clause is just checking thatg
# the file content is a token uuid :|
arvados-controller-resources-virtual-machines-{{ vm }}-get-vm_uuid-cmd-run:
  cmd.run:
    {%- if arvados.ruby.manage_ruby and arvados.ruby.use_rvm %}
    - prepend_path: /usr/local/rvm/gems/{{ arvados.ruby.pkg }}/bin
    {%- endif %}
    - name: {{ cmd_query_vm_uuid }} | head -1 | tee /tmp/{{ vm }}
    - require:
      - cmd: arvados-controller-resources-virtual-machines-{{ vm }}-record-cmd-run
      - gem: arvados-controller-package-install-gem-arvados-cli-installed
    - unless:
      - /bin/grep -qE "[a-z0-9]{5}-2x53u-[a-z0-9]{15}" /tmp/{{ vm }}

  # There's no direct way to query the scoped_token for a given virtual_machine
  # so we need to parse the api_client_authorization list through some jq
  {%- set cmd_query_scoped_token_url = 'VM_UUID=$(cat /tmp/' ~ vm ~ ') && ' ~
                                       ' ARVADOS_API_TOKEN=' ~ api_token ~
                                       ' ARVADOS_API_HOST=' ~ api_host ~ ' ' ~
                                       arv_command ~ ' api_client_authorization list |' ~
                                       ' /usr/bin/jq -e \'.items[].scopes[] | select(. == "GET ' ~
                                       '/arvados/v1/virtual_machines/\'${VM_UUID}\'/logins")\' && ' ~
                                       'unset VM_UUID'
  %}

# Create the VM scoped tokens
arvados-controller-resources-virtual-machines-{{ vm }}-scoped-token-cmd-run:
  cmd.run:
    - env:
      - ARVADOS_API_TOKEN: {{ api_token }}
      - ARVADOS_API_HOST: {{ api_host }}
    - name: |
        VM_UUID=$(cat /tmp/{{ vm }}) &&
        {{ arv_command }} --format=uuid \
          api_client_authorization \
          create \
          --api-client-authorization '{"scopes":["GET /arvados/v1/virtual_machines/'${VM_UUID}'/logins"]}'
    - unless: {{ cmd_query_scoped_token_url }}
    - require:
      - pkg: arvados-controller-package-install-pkg-installed
      - pkg: arvados-controller-resources-virtual-machines-jq-pkg-installed
      - cmd: arvados-controller-resources-virtual-machines-{{ vm }}-get-vm_uuid-cmd-run
      - gem: arvados-controller-package-install-gem-arvados-cli-installed

{%- endfor %}

# -*- coding: utf-8 -*-
# vim: ft=sls

# This state tries to query the controller using the parameters set in
# the `arvados.cluster.resources.virtual_machines` pillar, to get the
# scoped_token for the host and configure the arvados login-sync cron
# as described in https://doc.arvados.org/v2.0/install/install-shell-server.html

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_config_file = tplroot ~ '.config.file' %}
{%- from tplroot ~ "/map.jinja" import arvados with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

{%- set virtual_machines = arvados.cluster.resources.virtual_machines | default({}) %}
{%- set api_token = arvados.cluster.tokens.system_root | yaml_encode %}
{%- set api_host = arvados.cluster.Services.Controller.ExternalURL | regex_replace('^http(s?)://', '', ignorecase=true) %}

examples-arvados-shell-cron-add-login-sync-add-jq-pkg-installed:
  pkg.installed:
    - name: jq

{%- for vm, vm_params in virtual_machines.items() %}
  {%- set vm_name = vm_params.name | default(vm) %}

  # Check if any of the specified virtual_machines parameters corresponds to this instance
  # It should be an error if we get more than one occurrence
  {%- if vm_name in [grains['id'], grains['host'], grains['fqdn'], grains['nodename']] or
         backend in [grains['id'], grains['host'], grains['fqdn'], grains['nodename']] +
                    grains['ipv4'] + grains['ipv6'] %}

    {%- set cmd_query_vm_uuid = 'arv --short virtual_machine list' ~
                                ' --filters \'[["hostname", "=", "' ~ vm_name ~ '"]]\''
    %}

# We need to use the UUID generated in the previous command to see if there's a
# scoped token for it. There's no easy way to pass the value from a shellout
# to another state, so we store it in a temp file and use that in the next
# command. Flaky, mostly because the `unless` clause is just checking thatg
# the file content is a token uuid :|
examples-arvados-shell-cron-add-login-sync-add-{{ vm }}-get-vm_uuid-cmd-run:
  cmd.run:
    - env:
      - ARVADOS_API_TOKEN: {{ api_token }}
      - ARVADOS_API_HOST: {{ api_host }}
    - name: {{ cmd_query_vm_uuid }} | head -1 | tee /tmp/{{ vm }}
    - require:
      - cmd: examples-arvados-shell-cron-add-login-sync-add-resources-virtual-machines-{{ vm }}-record-cmd-run
    - unless:
      - /bin/grep -qE "fixme-2x53u-[a-z0-9]{15}" /tmp/{{ vm }}

  # There's no direct way to query the scoped_token for a given virtual_machine
  # so we need to parse the api_client_authorization list through some jq
  {%- set cmd_query_scoped_token_url = 'VM_UUID=$(cat /tmp/' ~ vm ~ ') && ' ~
                                       'arv api_client_authorization list | ' ~
                                       '/usr/bin/jq -e \'.items[]| select(.scopes[] == "GET ' ~
                                       '/arvados/v1/virtual_machines/\'${VM_UUID}\'/logins") | ' ~
                                       '.api_token\' | head -1 | tee /tmp/sctk' ~ vm ~ ' && ' ~
                                       'unset VM_UUID'
  %}

examples-arvados-shell-cron-add-login-sync-add-{{ vm }}-get-scoped_token-cmd-run:
  cmd.run:
    - env:
      - ARVADOS_API_TOKEN: {{ api_token }}
      - ARVADOS_API_HOST: {{ api_host }}
    - name: {{ cmd_query_scoped_token_url }}
    - require:
      - cmd: examples-arvados-shell-cron-add-login-sync-add-{{ vm }}-get-vm_uuid-cmd-run
    - unless:
      - test -s /tmp/sctk{{ vm }}

examples-arvados-shell-cron-add-login-sync-add-{{ vm }}-arvados-host-cron-env-present:
  cron.env_present:
    - name: ARVADOS_API_HOST
    - value: {{ api_host }}

examples-arvados-shell-cron-add-login-sync-add-{{ vm }}-arvados-api-cron-token-env-present:
  cron.env_present:
    - name: ARVADOS_API_TOKEN
    - value: __slot__:salt:cmd.run(cat /tmp/sctk{{ vm }})

examples-arvados-shell-cron-add-login-sync-add-{{ vm }}-arvados-api-cron-token-env-present:
  cron.env_present:
    - name: ARVADOS_VIRTUAL_MACHINE_UUID
    - value: __slot__:salt:cmd.run(cat /tmp/{{ vm }})

examples-arvados-shell-cron-add-login-sync-add-{{ vm }}-arvados-login-sync-cron-present:
  cron.present:
    minute: '*/2'
    cmd: arvados-login-sync

{%- endfor %}

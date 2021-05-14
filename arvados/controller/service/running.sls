# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_config_file = tplroot ~ '.config.file' %}
{%- from tplroot ~ "/map.jinja" import arvados with context %}

include:
  - ..package
  - {{ sls_config_file }}

arvados-controller-service-running-service-running:
  service.running:
    - name: {{ arvados.controller.service.name }}
    - enable: True
    - watch:
      - sls: {{ sls_config_file }}
    - require:
      - pkg: arvados-controller-package-install-pkg-installed

# Before being able to create resources, we need API to be up. When running the formula for
# the first time, it might be still being configured, so we add this workaround, as suggested at
# https://github.com/saltstack/salt/issues/19084#issuecomment-70317884
arvados-controller-service-running-service-ready-cmd-run:
  cmd.run:
    - name: |
        while ! (curl -s {{  arvados.cluster.Services.Controller.ExternalURL }} | \
                 grep -qE "req-[a-z0-9]{20}.{5}error_token") do
          echo 'waiting for API to be ready...'
          sleep 1
        done
    - timeout: 520
    - unless: |
        curl -s {{  arvados.cluster.Services.Controller.ExternalURL }} | \
        grep -qE "req-[a-z0-9]{20}.{5}error_token"
    - require:
      - service: arvados-controller-service-running-service-running

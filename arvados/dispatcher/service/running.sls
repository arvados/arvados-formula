# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_config_file = tplroot ~ '.config.file' %}
{%- from tplroot ~ "/map.jinja" import arvados with context %}

{%- if arvados.dispatcher.pkg.name != 'crunch-dispatch-local' %}
include:
  - ..package
  - {{ sls_config_file }}

arvados-dispatcher-service-running-service-running:
  service.running:
    - name: {{ arvados.dispatcher.service.name }}
    - enable: true
    - watch:
      - sls: {{ sls_config_file }}
    - require:
      - pkg: arvados-dispatcher-package-install-pkg-installed
    - only_if: test "{{ arvados.dispatcher.pkg.name }}" != "crunch-dispatch-local"
{%- endif %}

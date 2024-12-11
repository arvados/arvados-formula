# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_config_file = tplroot ~ '.config.file' %}
{%- from tplroot ~ "/map.jinja" import arvados with context %}

include:
  - ..package
  - {{ sls_config_file }}

arvados-api-service-drop-in-file:
  file.managed:
    - name: /etc/systemd/system/{{ arvados.api.service.name.rsplit('.', 1)|first }}.service.d/25-formula.conf
    - makedirs: True
    - template: jinja
    - context:
        arvados: {{ arvados | json }}
    - contents: |
        [Service]
        Environment=PASSENGER_ADDRESS={{ arvados.api.service.address }}
        Environment=PASSENGER_PORT={{ arvados.api.service.port }}

arvados-api-service-running-service-running:
  service.running:
    - name: {{ arvados.api.service.name }}
    - enable: True
    - watch:
      - sls: {{ sls_config_file }}
      - file: arvados-api-service-drop-in-file
    - require:
      - pkg: arvados-api-package-install-pkg-installed

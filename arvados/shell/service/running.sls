# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import arvados with context %}

include:
  - ..package
  - ..config

arvados-shell-shellinabox-service-running-service-running:
  service.running:
    - name: {{ arvados.shell.shellinabox.service.name }}
    - enable: True
    - watch:
      - file: arvados-shell-config-file-shellinabox-file-managed
    - require:
      - pkg: arvados-shell-package-install-pkg-installed

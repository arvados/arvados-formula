# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_config_file = tplroot ~ '.config.file' %}
{%- from tplroot ~ "/map.jinja" import arvados with context %}

arvados-workbench2-package-install-pkg-installed:
  pkg.installed:
    - name: {{ arvados.workbench2.pkg.name }}
    - version: {{ arvados.version }}
    - require:
      - sls: {{ sls_config_file }}

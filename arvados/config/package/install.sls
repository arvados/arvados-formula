# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import arvados with context %}

arvados-config-package-install-pkg-installed:
  pkg.installed:
    - name: arvados-server
    - version: {{ arvados.version }}

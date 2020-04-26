# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import arvados with context %}

arvados-workbench2-package-clean-pkg-removed:
  pkg.removed:
    - name: {{ arvados.workbench2.pkg.name }}

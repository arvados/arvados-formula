# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import arvados with context %}

arvados-keepproxy-package-install-pkg-installed:
  pkg.installed:
    - name: {{ arvados.keepproxy.pkg.name }}
    - version: {{ arvados.version }}

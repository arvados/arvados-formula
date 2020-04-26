# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import arvados with context %}

arvados-controller-service-clean-service-dead:
  service.dead:
    - name: {{ arvados.service.name }}
    - enable: False
    - require_in:
      - pkg: arvados-controller-package-clean-pkg-removed

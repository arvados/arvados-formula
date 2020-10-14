# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import arvados with context %}

{% if arvados.use_upstream_repo -%}
  {% if grains.get('os_family') == 'Debian' -%}
arvados-repo-clean-repo-absent:
  pkgrepo.absent:
    - file: {{ arvados.repo.file }}
    - key_url: {{ arvados.repo.key_url }}

  {%- elif grains.get('os_family') == 'RedHat' %}
arvados-repo-clean-repo-absent:
  pkgrepo.absent:
    - file: {{ arvados.repo.file }}

  {%- else %}
arvados_repo-clean-repo-absent: {}
  {%- endif %}
{%- endif %}

# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import arvados with context %}

/etc/apt/preferences.d/arvados:
{%- if arvados.version != 'latest' %}
  file.managed:
    - contents: |
        # This file managed by Salt, do not edit by hand!!
        Package: /arvados/ crunch* *crunchstat* keep*
        Pin: version {{ arvados.version }}
        Pin-Priority: 995
    - require_in:
      - file: arvados-repo-install-file-managed
{%- else %}
  file.absent
{%- endif %}
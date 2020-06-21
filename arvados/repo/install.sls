# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import arvados with context %}

{%- if arvados.use_upstream_repo -%}
  {%- if grains.get('os_family') == 'Debian' -%}
    {%- if arvados.release == 'testing' %}
      {%- set release = grains.get('lsb_distrib_codename') ~ '-testing' %}
    {%- elif arvados.release == 'development' %}
      {%- set release = grains.get('lsb_distrib_codename') ~ '-dev' %}
    {%- else %}
      {%- set release = grains.get('lsb_distrib_codename') %}
    {%- endif %}
arvados-repo-install-pkgrepo-managed:
  pkgrepo.managed:
    - humanname: {{ arvados.repo.humanname }}
    - name: deb {{ arvados.repo.url_base }}/ {{ release }} main
    - file: {{ arvados.repo.file }}
    - key_url: {{ arvados.repo.key_url }}

  {%- elif grains.get('os_family') == 'RedHat' %}
    {%- if arvados.release == 'testing' %}
      {%- set repo_url = 'http://rpm.arvados.org/CentOS/$releasever/testing/$basearch/' %}
    {%- elif arvados.release == 'development' %}
      {%- set repo_url = 'http://rpm.arvados.org/CentOS/$releasever/dev/$basearch/' %}
    {%- else %}
      {%- set repo_url = arvados.repo.url_base %}
    {%- endif %}
arvados-repo-install-pkgrepo-managed:
  pkgrepo.managed:
    - name: arvados
    - file: {{ arvados.repo.file }}
    - humanname: {{ arvados.repo.humanname }}
    - baseurl: {{ repo_url }}
    - gpgcheck: 1
    - gpgkey: {{ arvados.repo.key_url }}

  {%- else %}
arvados-repo-install-pkgrepo-managed: {}
  {%- endif %}
{%- endif %}

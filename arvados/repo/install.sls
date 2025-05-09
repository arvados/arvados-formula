# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import arvados with context %}

{%- if arvados.use_upstream_repo %}
  {%- if grains.get('os_family') == 'Debian' %}
include:
  - .debian-pin
    {%- set distro = grains.get('lsb_distrib_codename') %}

    {%- if arvados.release == 'testing' %}
      {%- set release = distro ~ '-testing' %}
    {%- elif arvados.release == 'development' %}
      {%- set release = distro ~ '-dev' %}
    {%- else %}
      {%- set release = distro %}
    {%- endif %}

arvados-repo-install-pkgrepo-keyring-managed:
  file.managed:
    - name: {{ arvados.repo.keyring_file }}
    - source:
      - {{ arvados.repo.keyring_source }}
    - source_hash: sha256={{ arvados.repo.keyring_source_hash }}
    - require_in:
      - file: arvados-repo-install-file-managed

arvados-repo-install-file-managed:
  file.managed:
    - name: {{ arvados.repo.file }}
    - contents: >
        deb [signed-by={{ arvados.repo.keyring_file }} arch=amd64]
        {{ arvados.repo.url_base }}/{{ distro }} {{ release }} main

  {%- elif grains.get('os_family') == 'RedHat' %}
    {%- if arvados.release == 'testing' %}
      {%- set repo_url = 'http://rpm.arvados.org/RHEL/$releasever/testing/$basearch/' %}
    {%- elif arvados.release == 'development' %}
      {%- set repo_url = 'http://rpm.arvados.org/RHEL/$releasever/dev/$basearch/' %}
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

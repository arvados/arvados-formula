# -*- coding: utf-8 -*-
# vim: ft=sls

# Copyright (C) The Arvados Authors. All rights reserved.
#
# SPDX-License-Identifier: Apache-2.0

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_config_file = tplroot ~ '.config.file' %}
{%- set sls_ruby_install = tplroot ~ '.ruby.package.install' %}
{%- from tplroot ~ "/map.jinja" import arvados with context %}

include:
  # The workbench server requires a valid config BEFORE installing...
  - {{ sls_config_file }}
  - {{ sls_ruby_install }}

arvados-workbench-package-install-gems-deps-pkg-installed:
  pkg.installed:
    - pkgs: {{ arvados.ruby.gems_deps | json }}
    - onlyif: test "{{ arvados.ruby.manage_gems_deps | lower }}" = "true"

arvados-workbench-package-install-pkg-installed:
  pkg.installed:
    - name: {{ arvados.workbench.pkg.name }}
    - version: {{ arvados.version }}
    - refresh: true
    - require:
      {%- if arvados.ruby.manage_ruby %}
      - pkg: arvados-ruby-package-install-ruby-pkg-installed
      {%- endif %}
      - sls: {{ sls_config_file }}

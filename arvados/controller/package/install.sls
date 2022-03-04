# -*- coding: utf-8 -*-
# vim: ft=sls

# Copyright (C) The Arvados Authors. All rights reserved.
#
# SPDX-License-Identifier: Apache-2.0

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_ruby_install = tplroot ~ '.ruby.package.install' %}
{%- from tplroot ~ "/map.jinja" import arvados with context %}

{%- if arvados.ruby.manage_ruby %}
  {%- set ruby_dep = 'rvm' if arvados.ruby.use_rvm else 'pkg' %}
{%- endif %}

include:
  - {{ sls_ruby_install }}

arvados-controller-package-install-gems-deps-pkg-installed:
  pkg.installed:
    - pkgs: {{ arvados.ruby.gems_deps | unique | json }}
    - onlyif: test "{{ arvados.ruby.manage_gems_deps | lower }}" = "true"

{%- for gm in arvados.api.gem.name | unique %}
arvados-controller-package-install-gem-{{ gm }}-installed:
  gem.installed:
    - name: {{ gm }}
    {%- if arvados.ruby.use_rvm %}
    - ruby: {{ arvados.ruby.pkg }}
    {%- endif %}
    - require:
      - pkg: arvados-controller-package-install-gems-deps-pkg-installed
      {%- if arvados.ruby.manage_ruby %}
      - {{ ruby_dep }}: arvados-ruby-package-install-ruby-{{ ruby_dep }}-installed
      {%- endif %}
    - require_in:
      - pkg: arvados-controller-package-install-pkg-installed
{%- endfor %}

arvados-controller-package-install-pkg-installed:
  pkg.installed:
    - name: {{ arvados.controller.pkg.name }}
    - version: {{ arvados.version }}
    - refresh: true

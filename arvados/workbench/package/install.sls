# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_config_file = tplroot ~ '.config.file' %}
{%- from tplroot ~ "/map.jinja" import arvados with context %}

# The workbench server requires a valid config BEFORE installing...
include:
  - {{ sls_config_file }}

arvados-workbench-package-install-ruby-pkg-installed:
  pkg.installed:
    - name: {{ arvados.ruby.pkg }}
    - only_if: test "{{ arvados.ruby.manage_ruby | lower }}" = "true"

arvados-workbench-package-install-gems-deps-pkg-installed:
  pkg.installed:
    - pkgs: {{ arvados.ruby.gems_deps | json }}
    - only_if: test "{{ arvados.ruby.manage_gems_deps | lower }}" = "true"

arvados-workbench-package-install-pkg-installed:
  pkg.installed:
    - name: {{ arvados.workbench.pkg.name }}
    - version: {{ arvados.version }}
    - require:
      - sls: {{ sls_config_file }}

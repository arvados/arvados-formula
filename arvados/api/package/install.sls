# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_config_file = tplroot ~ '.config.file' %}
{%- set sls_ruby_install = tplroot ~ '.ruby.package.install' %}
{%- from tplroot ~ "/map.jinja" import arvados with context %}

{%- if arvados.ruby.manage_ruby %}
  {%- set ruby_dep = 'rvm' if arvados.ruby.use_rvm else 'pkg' %}
{%- endif %}

include:
  # The API server requires a valid config BEFORE installing...
  - {{ sls_config_file }}
  - {{ sls_ruby_install }}

arvados-api-package-install-gems-deps-pkg-installed:
  pkg.installed:
    - pkgs: {{ arvados.ruby.gems_deps | unique | json }}
    - only_if: test "{{ arvados.ruby.manage_gems_deps | lower }}" = "true"

{%- for gm in arvados.api.gem.name | unique %}
arvados-api-package-install-gem-{{ gm }}-installed:
  gem.installed:
    - name: {{ gm }}
    - require:
      - pkg: arvados-api-package-install-gems-deps-pkg-installed
      {%- if arvados.ruby.manage_ruby %}
      - {{ ruby_dep }}: arvados-ruby-package-install-ruby-{{ ruby_dep }}-installed
      {%- endif %}
    - require_in:
      - pkg: arvados-api-package-install-pkg-installed
{%- endfor %}

arvados-api-package-install-pkg-installed:
  pkg.installed:
    - name: {{ arvados.api.pkg.name }}
    - version: {{ arvados.version }}
    - require:
      - sls: {{ sls_config_file }}

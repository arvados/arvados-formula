# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_config_file = tplroot ~ '.config.file' %}
{%- from tplroot ~ "/map.jinja" import arvados with context %}

# The API server requires a valid config BEFORE installing...
include:
  - {{ sls_config_file }}

arvados-api-package-install-ruby-pkg-installed:
  pkg.installed:
    - name: {{ arvados.ruby.pkg }}
    - only_if: {{ arvados.ruby.manage_ruby }}

arvados-api-package-install-gems-deps-pkg-installed:
  pkg.installed:
    - pkgs: {{ arvados.ruby.gems_deps | json }}
    - only_if: {{ arvados.ruby.manage_gems_deps }}

{% for gm in arvados.api.gem.name %}
arvados-api-package-install-gem-{{ gm }}-installed:
  gem.installed:
    - name: {{ gm }}
    - require:
      - pkg: arvados-api-package-install-gems-deps-pkg-installed
    - require_in:
      - pkg: arvados-api-package-install-pkg-installed
{% endfor %}

arvados-api-package-install-pkg-installed:
  pkg.installed:
    - pkgs: {{ arvados.api.pkg.name | json }}
    - require:
      - sls: {{ sls_config_file }}

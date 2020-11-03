# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import arvados with context %}

arvados-dispatcher-package-install-pkg-installed:
  pkg.installed:
    - name: {{ arvados.dispatcher.pkg.name }}
    - version: {{ arvados.version }}

# FIXME! Until https://dev.arvados.org/issues/16995 makes it to
# a new release, this is required so the dependency is installed
{%- if arvados.dispatcher.pkg.name == 'crunch-dispatch-local' %}
arvados-dispatcher-package-install-crunch-run-pkg-installed:
  pkg.installed:
    - name: crunch-run
    - require:
      - pkg: arvados-dispatcher-package-install-pkg-installed
    - version: {{ arvados.version }}
{%- endif %}

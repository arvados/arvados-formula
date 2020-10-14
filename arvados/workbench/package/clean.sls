# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import arvados with context %}

arvados-workbench-package-clean-gems-deps-pkg-removed:
  pkg.removed:
    - pkgs: {{ arvados.ruby.gems_deps | json }}
    - only_if: test "{{ arvados.ruby.manage_gems_deps | lower }}" = "true"

arvados-workbench-package-clean-pkg-removed:
  pkg.removed:
    - name: {{ arvados.workbench.pkg.name }}

arvados-workbench-package-clean-ruby-pkg-removed:
  pkg.removed:
    - name: {{ arvados.ruby.pkg }}
    - only_if: test "{{ arvados.ruby.manage_ruby | lower }}" = "true"

# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import arvados with context %}

{% for gm in arvados.shell.gem.name %}
arvados-shell-package-clean-gem-{{ gm }}-removed:
  gem.removed:
    - name: {{ gm }}
    - require_in:
      - pkg: arvados-shell-package-clean-gems-deps-pkg-removed
{% endfor %}

arvados-shell-package-clean-gems-deps-pkg-removed:
  pkg.removed:
    - pkgs: {{ arvados.ruby.gems_deps | json }}
    - only_if: test "{{ arvados.ruby.manage_gems_deps | lower }}" = "true"

arvados-shell-package-clean-pkg-removed:
  pkg.removed:
    - pkgs: {{ arvados.shell.pkg.name | json }}

arvados-shell-package-clean-ruby-pkg-removed:
  pkg.removed:
    - name: {{ arvados.ruby.pkg }}
    - only_if: test "{{ arvados.ruby.manage_ruby | lower }}" = "true"

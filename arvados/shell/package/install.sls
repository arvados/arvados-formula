# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import arvados with context %}

arvados-shell-package-install-pkg-installed:
  pkg.installed:
    - pkgs: {{ arvados.shell.pkg.name | json }}

arvados-shell-package-install-ruby-pkg-installed:
  pkg.installed:
    - name: {{ arvados.ruby.pkg }}
    - only_if: {{ arvados.ruby.manage_ruby }}

arvados-shell-package-install-gems-deps-pkg-installed:
  pkg.installed:
    - pkgs: {{ arvados.ruby.gems_deps | json }}
    - only_if: {{ arvados.ruby.manage_gems_deps }}

{% for gm in arvados.shell.gem.name %}
arvados-shell-package-install-gem-{{ gm }}-installed:
  gem.installed:
    - name: {{ gm }}
    - require:
      - pkg: arvados-shell-package-install-gems-deps-pkg-installed
{% endfor %}

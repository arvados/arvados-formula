# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_ruby_install = tplroot ~ '.ruby.package.install' %}
{%- from tplroot ~ "/map.jinja" import arvados with context %}

{%- if arvados.ruby.manage_ruby %}
  {%- set ruby_dep = 'rvm' if arvados.ruby.use_rvm else 'pkg' %}
{%- endif %}

include:
  - {{ sls_ruby_install }}

arvados-shell-package-install-pkg-installed:
  pkg.installed:
    - pkgs:
      {%- for package in arvados.shell.pkg.name %}
        # We use version for our Arvados packages only
        {%- if package in [
          'arvados-client',
          'arvados-src',
          'libpam-arvados-go',
          'python3-arvados-fuse',
          'python3-arvados-python-client',
          'python3-arvados-cwl-runner',
        ] %}
      - {{ package }}: {{ arvados.version }}
        {%- else %}
      - {{ package }}
        {%- endif %}
      {%- endfor %}

arvados-shell-package-install-gems-deps-pkg-installed:
  pkg.installed:
    - pkgs: {{ arvados.ruby.gems_deps | json }}
    - only_if: test "{{ arvados.ruby.manage_gems_deps | lower }}" = "true"

{%- for gm in arvados.shell.gem.name %}
arvados-shell-package-install-gem-{{ gm }}-installed:
  gem.installed:
    - name: {{ gm }}
    - require:
      {%- if arvados.ruby.manage_ruby %}
      - {{ ruby_dep }}: arvados-ruby-package-install-ruby-{{ ruby_dep }}-installed
      {%- endif %}
      - pkg: arvados-shell-package-install-gems-deps-pkg-installed
{%- endfor %}

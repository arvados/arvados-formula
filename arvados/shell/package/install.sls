# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_ruby_install = tplroot ~ '.ruby.package.install' %}
{%- from tplroot ~ "/map.jinja" import arvados with context %}

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
          'python3-arvados-fuse',
          'python3-arvados-python-client',
          'python3-arvados-cwl-runner',
        ] %}
      - {{ package }}: {{ arvados.version }}
        {%- else %}
      - {{ package }}
        {%- endif %}
      {%- endfor %}
    - refresh: true

arvados-shell-package-install-gems-deps-pkg-installed:
  pkg.installed:
    - pkgs: {{ arvados.ruby.gems_deps | json }}
    - onlyif: test "{{ arvados.ruby.manage_gems_deps | lower }}" = "true"

{%- for gm in arvados.shell.gem.name %}
arvados-shell-package-install-gem-{{ gm }}-installed:
  gem.installed:
    - name: {{ gm }}
    - require:
      {%- if arvados.ruby.manage_ruby %}
      - pkg: arvados-ruby-package-install-ruby-pkg-installed
      {%- endif %}
      - pkg: arvados-shell-package-install-gems-deps-pkg-installed
{%- endfor %}

# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import arvados with context %}

{%- if arvados.ruby.manage_ruby %}

  {%- if arvados.ruby.use_rvm %}
  # Centos 7 has no python3-gnupg package, so using gpg.present
  # will fail when it can't list the existing keys.
  # Doing it the hard way
arvados-ruby-package-install-gpg-cmd-run-gpg-michal-papis:
  cmd.run:
    - name: /bin/gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
    - unless:
      - /bin/gpg --list-keys 409B6B1796C275462A1703113804BB82D39DC0E3

arvados-ruby-package-install-gpg-cmd-run-gpg-piotr-kuczynski:
  cmd.run:
    - name: /bin/gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
    - unless:
      - /bin/gpg --list-keys 7D2BAF1CF37B13E2069D6956105BD0E739499BDB

arvados-ruby-package-install-rvm-cmd-run-curl:
  cmd.run:
    - name: curl -s -L http://get.rvm.io | bash -s stable
    - unless: test -f /usr/local/rvm/bin/rvm
    - require:
      - cmd: arvados-ruby-package-install-gpg-cmd-run-gpg-michal-papis
      - cmd: arvados-ruby-package-install-gpg-cmd-run-gpg-piotr-kuczynski

arvados-ruby-package-install-ruby-rvm-installed:
  rvm.installed:
    - name: {{ arvados.ruby.pkg }}
    - default: true
    - require:
      - cmd: arvados-ruby-package-install-rvm-cmd-run-curl

  {%- else %}

arvados-ruby-package-install-ruby-pkg-installed:
  pkg.installed:
    - name: {{ arvados.ruby.pkg }}
  {%- endif %}
{%- endif %}

# -*- coding: utf-8 -*-
# vim: ft=sls

# Copyright (C) The Arvados Authors. All rights reserved.
#
# SPDX-License-Identifier: Apache-2.0

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import arvados with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

{%- if arvados.ruby.manage_ruby %}

  {%- if arvados.ruby.use_rvm %}

    # Centos 7 has a too old postgresql package and we need a newer one
    {%- if grains.os_family in ('RedHat',) %}
arvados-ruby-package-install-ruby-rvm-deps-centos-scl-release-pkg-installed:
  pkg.installed:
    - name: centos-release-scl

arvados-ruby-package-install-ruby-rvm-deps-rh-postgres-libs-pkg-installed:
  pkg.installed:
    - name: rh-postgresql{{ arvados.api.postgresql_version }}-postgresql-libs
    - unless: rpm -q postgresql{{ arvados.api.postgresql_version }}-libs
    - require_in:
      - cmd: arvados-ruby-package-install-rvm-cmd-run-curl
    {%- endif %}

  # Centos 7 has no python3-gnupg package, so using gpg.present
  # will fail when it can't list the existing keys.
  # Doing it the hard way
arvados-ruby-package-install-file-managed-gpg-michal-papis:
  file.managed:
    - name: /tmp/gpg-michal-papis-409B6B1796C275462A1703113804BB82D39DC0E3.key
    - source: {{ files_switch(['gpg-michal-papis-409B6B1796C275462A1703113804BB82D39DC0E3.key'],
                              lookup='arvados-ruby-package-install-file-managed-gpg-michal-papis',
                              use_subpath=True
                 )
              }}
    - mode: '0644'
    - user: root
    - group: root
    - unless:
      - gpg --list-keys 409B6B1796C275462A1703113804BB82D39DC0E3

arvados-ruby-package-install-cmd-run-gpg-michal-papis:
  cmd.run:
    - name: gpg --import /tmp/gpg-michal-papis-409B6B1796C275462A1703113804BB82D39DC0E3.key
    - unless:
      - gpg --list-keys 409B6B1796C275462A1703113804BB82D39DC0E3

arvados-ruby-package-install-file-managed-gpg-piotr-kuczynski:
  file.managed:
    - name: /tmp/gpg-piotr-kuczynski-7D2BAF1CF37B13E2069D6956105BD0E739499BDB.key
    - source: {{ files_switch(['gpg-piotr-kuczynski-7D2BAF1CF37B13E2069D6956105BD0E739499BDB.key'],
                              lookup='arvados-ruby-package-install-file-managed-gpg-piotr-kuczynski',
                              use_subpath=True
                 )
              }}
    - mode: '0644'
    - user: root
    - group: root
    - unless:
      - gpg --list-keys 7D2BAF1CF37B13E2069D6956105BD0E739499BDB

arvados-ruby-package-install-cmd-run-gpg-piotr-kuczynski:
  cmd.run:
    - name: gpg --import /tmp/gpg-piotr-kuczynski-7D2BAF1CF37B13E2069D6956105BD0E739499BDB.key
    - unless:
      - gpg --list-keys 7D2BAF1CF37B13E2069D6956105BD0E739499BDB

arvados-ruby-package-install-rvm-cmd-run-curl:
  cmd.run:
    - name: curl -s -L http://get.rvm.io | bash -s stable
    - unless: test -f /usr/local/rvm/bin/rvm
    - require:
      - cmd: arvados-ruby-package-install-cmd-run-gpg-michal-papis
      - cmd: arvados-ruby-package-install-cmd-run-gpg-piotr-kuczynski

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

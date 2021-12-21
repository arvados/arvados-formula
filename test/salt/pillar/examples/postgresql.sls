---
# Copyright (C) The Arvados Authors. All rights reserved.
#
# SPDX-License-Identifier: AGPL-3.0

### POSTGRESQL
postgres:
  # Centos-7 and Ubuntu-18.04's postgres packages are too old, so we need to force using upstream's
  # This is not required in Debian's family as they already ship with PG +11
  {%- if salt['grains.get']('osfinger') in ['Ubuntu-18.04', 'CentOS Linux-7'] %}
  use_upstream_repo: true
  version: '12'

    {%- if salt['grains.get']('osfinger') == 'CentOS Linux-7' %}
  pkgs_deps:
    - libicu
    - libxslt
    - systemd-sysv
  pkgs_extra:
    - postgresql12-contrib

    {%- endif %}

  {%- else %}
  use_upstream_repo: false
  pkgs_extra:
    - postgresql-contrib
  {%- endif %}
  postgresconf: |-
    listen_addresses = '*'  # listen on all interfaces
    #ssl = on
    #ssl_cert_file = '/etc/ssl/certs/arvados-snakeoil-cert.pem'
    #ssl_key_file = '/etc/ssl/private/arvados-snakeoil-cert.key'
  acls:
    - ['local', 'all', 'postgres', 'peer']
    - ['local', 'all', 'all', 'peer']
    - ['host', 'all', 'all', '127.0.0.1/32', 'md5']
    - ['host', 'all', 'all', '::1/128', 'md5']
    - ['host', 'arvados', 'arvados', '127.0.0.1/32']
  users:
    arvados:
      ensure: present
      password: changeme_arvados

  # tablespaces:
  #   arvados_tablespace:
  #     directory: /path/to/some/tbspace/arvados_tbsp
  #     owner: arvados

  databases:
    arvados:
      owner: arvados
      template: template0
      lc_ctype: en_US.utf8
      lc_collate: en_US.utf8
      # tablespace: arvados_tablespace
      schemas:
        public:
          owner: arvados
      extensions:
        pg_trgm:
          if_not_exists: true
          schema: public

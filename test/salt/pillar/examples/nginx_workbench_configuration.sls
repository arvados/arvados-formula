---
# Copyright (C) The Arvados Authors. All rights reserved.
#
# SPDX-License-Identifier: Apache-2.0

{%- if grains.os_family in ('RedHat',) %}
  {%- set group = 'nginx' %}
{%- else %}
  {%- set group = 'www-data' %}
{%- endif %}

### ARVADOS
arvados:
  config:
    group: {{ group }}

### NGINX
nginx:
  ### SITES
  servers:
    managed:
      ### DEFAULT
      arvados_workbench_default.conf:
        enabled: true
        overwrite: true
        config:
          - server:
            - server_name: workbench.fixme.example.net
            - listen:
              - 80
            - location /.well-known:
              - root: /var/www
            - location /:
              - return: '301 https://$host$request_uri'

      arvados_workbench_ssl.conf:
        enabled: true
        overwrite: true
        config:
          - server:
            - server_name: workbench.fixme.example.net
            - listen:
              - 443 http2 ssl
            - root: /var/www/arvados-workbench/current/public
            - passenger_enabled: 'on'
            - index: index.html index.htm
            - include: 'snippets/ssl_hardening_default.conf'
            # - include: 'snippets/letsencrypt.conf'
            - include: 'snippets/ssl_snakeoil.conf'
            # yamllint disable-line rule:line-length
            - access_log: /var/log/nginx/workbench.fixme.example.net.access.log combined
            - error_log: /var/log/nginx/workbench.fixme.example.net.error.log


---
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
      arvados_api.conf:
        enabled: true
        overwrite: true
        config:
          - server:
            - listen: '127.0.0.2:8004'
            - server_name: api
            - root: /var/www/arvados-api/current/public
            - index:  index.html index.htm
            - access_log: /var/log/nginx/api.fixme.example.net-upstream.access.log combined
            - error_log: /var/log/nginx/api.fixme.example.net-upstream.error.log
            - passenger_enabled: 'on'
            - client_max_body_size: 128m

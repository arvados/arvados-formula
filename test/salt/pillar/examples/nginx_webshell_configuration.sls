---
# This parameter will be used here to generate a list of upstreams and vhosts.
# This dict is here for convenience and should be managed some other way, but the
# different ways of orchestration that can be used for this are outside the scope
# of this formula and their examples.
# These upstreams should match those defined in `arvados:cluster:resources:virtual_machines`
{% set webshell_virtual_machines = {
  'shell1': {
    'name': 'webshell1',
    'backend': '1.2.3.4',
    'port': 4200,
  },
  'shell.internal': {},
  'webshell3': {
    'backend': '4.3.2.1',
    'port': 4500,
  }
}
%}

### NGINX
nginx:
  ### SERVER
  server:
    config:
      ### STREAMS
      http:
        {%- for vm, params in webshell_virtual_machines.items() %}
          {%- set vm_name = params.name | default(vm) %}
          {%- set vm_backend = params.backend | default(vm_name) %}
          {%- set vm_port = params.port | default(4200) %}

        upstream {{ vm_name }}_upstream:
          - server: '{{ vm_backend }}:{{ vm_port }} fail_timeout=10s'

        {%- endfor %}

  ### SITES
  servers:
    managed:
      arvados_webshell_default.conf:
        enabled: true
        overwrite: true
        config:
          - server:
            - server_name: webshell.fixme.example.net
            - listen:
              - 80
            - location /.well-known:
              - root: /var/www
            - location /:
              - return: '301 https://$host$request_uri'

      arvados_webshell_ssl.conf:
        enabled: true
        overwrite: true
        config:
          - server:
            - server_name: webshell.fixme.example.net
            - listen:
              - 443 http2 ssl
            - index: index.html index.htm
            {%- for vm, params in webshell_virtual_machines.items() %}
              {%- set vm_name = params.name | default(vm) %}
            - location /{{ vm_name }}:
              - proxy_pass: 'http://{{ vm_name }}_upstream'
              - proxy_read_timeout: 90
              - proxy_connect_timeout: 90
              - proxy_set_header: 'Host $http_host'
              - proxy_set_header: 'X-Real-IP $remote_addr'
              - proxy_set_header: X-Forwarded-Proto https
              - proxy_set_header: 'X-Forwarded-For $proxy_add_x_forwarded_for'
              - proxy_ssl_session_reuse: 'off'

              - "if ($request_method = 'OPTIONS')":
                - add_header: "'Access-Control-Allow-Origin' '*'"
                - add_header: "'Access-Control-Allow-Methods' 'GET, POST, OPTIONS'"
                - add_header: "'Access-Control-Allow-Headers' 'DNT,X-CustomHeader,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type'"
                - add_header: "'Access-Control-Max-Age' 1728000"
                - add_header: "'Content-Type' 'text/plain charset=UTF-8'"
                - add_header: "'Content-Length' 0"
                - return: 204

              - "if ($request_method = 'POST')":
                - add_header: "'Access-Control-Allow-Origin' '*'"
                - add_header: "'Access-Control-Allow-Methods' 'GET, POST, OPTIONS'"
                - add_header: "'Access-Control-Allow-Headers' 'DNT,X-CustomHeader,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type'"

              - "if ($request_method = 'GET')":
                - add_header: "'Access-Control-Allow-Origin' '*'"
                - add_header: "'Access-Control-Allow-Methods' 'GET, POST, OPTIONS'"
                - add_header: "'Access-Control-Allow-Headers' 'DNT,X-CustomHeader,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type'"
            {%- endfor %}
            - include: 'snippets/ssl_hardening_default.conf'
            # - include: 'snippets/letsencrypt.conf'
            - include: 'snippets/ssl_snakeoil.conf'
            - access_log: /var/log/nginx/webshell.fixme.example.net.access.log combined
            - error_log: /var/log/nginx/webshell.fixme.example.net.error.log


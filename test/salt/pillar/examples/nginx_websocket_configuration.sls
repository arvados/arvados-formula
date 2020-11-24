---
### NGINX
nginx:
  ### SERVER
  server:
    config:
      ### STREAMS
      http:
        upstream websocket_upstream:
          - server: 'ws.internal:8005 fail_timeout=10s'

  servers:
    managed:
      ### DEFAULT
      arvados_websocket_default.conf:
        enabled: true
        overwrite: true
        config:
          - server:
            - server_name: ws.fixme.example.net
            - listen:
              - 80
            - location /.well-known:
              - root: /var/www
            - location /:
              - return: '301 https://$host$request_uri'

      arvados_websocket_ssl.conf:
        enabled: true
        overwrite: true
        config:
          - server:
            - server_name: ws.fixme.example.net
            - listen:
              - 443 http2 ssl
            - index: index.html index.htm
            - location /:
              - proxy_pass: 'http://websocket_upstream'
              - proxy_read_timeout: 600
              - proxy_connect_timeout: 90
              - proxy_redirect: 'off'
              - proxy_set_header: 'Host $host'
              - proxy_set_header: 'X-Real-IP $remote_addr'
              - proxy_set_header: 'Upgrade $http_upgrade'
              - proxy_set_header: 'Connection "upgrade"'
              - proxy_set_header: 'X-Forwarded-For $proxy_add_x_forwarded_for'
              - proxy_buffering: 'off'
            - client_body_buffer_size: 64M
            - client_max_body_size: 64M
            - proxy_http_version: '1.1'
            - proxy_request_buffering: 'off'
            - include: 'snippets/ssl_hardening_default.conf'
            # - include: 'snippets/letsencrypt.conf'
            - include: 'snippets/ssl_snakeoil.conf'
            - access_log: /var/log/nginx/ws.fixme.example.net.access.log combined
            - error_log: /var/log/nginx/ws.fixme.example.net.error.log

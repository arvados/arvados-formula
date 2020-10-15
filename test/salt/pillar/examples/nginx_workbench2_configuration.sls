---
### ARVADOS
arvados:
  config:
    group: www-data

### NGINX
nginx:
  ### SITES
  servers:
    managed:
      ### DEFAULT
      arvados_workbench2_default:
        enabled: true
        overwrite: true
        config:
          - server:
            - server_name: workbench2.fixme.example.net
            - listen:
              - 80
            - location /.well-known:
              - root: /var/www
            - location /:
              - return: '301 https://$host$request_uri'

      arvados_workbench2_ssl:
        enabled: true
        overwrite: true
        config:
          - server:
            - server_name: workbench2.fixme.example.net
            - listen:
              - 443 http2 ssl
            - index: index.html index.htm
            - location /:
              - root: /var/www/arvados-workbench2/workbench2
              - try_files: '$uri $uri/ /index.html'
              - 'if (-f $document_root/maintenance.html)':
                - return: 503
            - location /config.json:
              - return: {{ "200 '" ~ '{"API_HOST":"fixme.example.net"}' ~ "'" }}
            # - include: 'snippets/letsencrypt.conf'
            - include: 'snippets/snakeoil.conf'
            - access_log: /var/log/nginx/workbench2.fixme.example.net.access.log combined
            - error_log: /var/log/nginx/workbench2.fixme.example.net.error.log

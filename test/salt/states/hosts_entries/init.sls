arvados_hosts_entries:
  host.present:
    - ip: {{ grains.get('ipv4')[0] }}
    - names:
      - {{ grains.get('fqdn') }}
      {%- for entry in [
          'keep',
          'keep0',
          'collections',
          'download',
          'ws',
          'workbench',
          'workbench2'
        ]
      %}
      - {{ entry }}
      # FIXME! This just works for our testings.
      # Won't work if the cluster name != host name
      - {{ entry }}.{{ grains.get('host') }}.{{ grains.get('domain') }}
      {%- endfor %}

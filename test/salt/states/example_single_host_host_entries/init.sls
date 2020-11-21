{% set curr_tpldir = tpldir %}
{% set tpldir = 'arvados' %}
{% from "arvados/map.jinja" import arvados with context %}
{% set tpldir = curr_tpldir %}

arvados_hosts_entries:
  host.present:
    - ip: {{ grains.get('ipv4')[0] }}
    - names:
      - {{ arvados.cluster.name }}.{{ arvados.cluster.domain }}
      # FIXME! This just works for our testings.
      # Won't work if the cluster name != host name
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
      - {{ entry }}.{{ arvados.cluster.name }}.{{ arvados.cluster.domain }}
      {%- endfor %}

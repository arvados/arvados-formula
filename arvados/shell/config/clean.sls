# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import arvados with context %}

arvados-shell-config-clean-file-shellinabox-absent:
  file.absent:
    - name: {{ arvados.shell.shellinabox.config }}
    - watch_in:
        - sls: {{ sls_service_clean }}

arvados-shell-config-clean-file-libpam-arvados-absent:
  file.absent:
    - name: {{ arvados.shell.libpam-arvados.config }}
    - watch_in:
        - sls: {{ sls_service_clean }}

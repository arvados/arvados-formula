# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_config_file = tplroot ~ '.config.file' %}
{%- from tplroot ~ "/map.jinja" import arvados with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

include:
  - ..package
  - {{ sls_config_file }}
  - .running

{%- if arvados.dispatcher.pkg.name == 'crunch-dispatch-local' %}
arvados-dispatcher-service-file-file-managed-crunch-run-sh:
  file.managed:
    - name: /usr/local/bin/crunch-run.sh
    - source: {{ files_switch(['crunch-run-sh.tmpl'],
                              lookup='arvados-dispatcher-service-file-file-managed-crunch-run-sh',
                              use_subpath=True
                 )
              }}
    - mode: '0755'
    - user: root
    - group: root
    - makedirs: True
    - template: jinja
    - context:
        arvados: {{ arvados | json }}
    - require:
      - pkg: arvados-dispatcher-package-install-pkg-installed

arvados-dispatcher-service-file-file-managed-crunch-dispatch-local-service:
  file.managed:
    - name: /etc/systemd/system/crunch-dispatch-local.service
    - source: {{ files_switch(['crunch-dispatch-local-service.tmpl'],
                              lookup='arvados-dispatcher-service-file-file-managed-crunch-dispatch-local-service',
                              use_subpath=True
                 )
              }}
    - mode: '0644'
    - user: root
    - group: root
    - makedirs: True
    - template: jinja
    - context:
        arvados: {{ arvados | json }}
    - require:
      - file: arvados-dispatcher-service-file-file-managed-crunch-run-sh
      - pkg: arvados-dispatcher-package-install-pkg-installed
  cmd.run:
    - name: systemctl daemon-reload
    - require_in:
      - service: arvados-dispatcher-service-running-service-running
    - require:
      - file: arvados-dispatcher-service-file-file-managed-crunch-dispatch-local-service
{%- endif %}

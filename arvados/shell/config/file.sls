# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_package_install = tplroot ~ '.shell.package.install' %}
{%- from tplroot ~ "/map.jinja" import arvados with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

include:
  - {{ sls_package_install }}

arvados-shell-config-file-shellinabox-file-managed:
  file.managed:
    - name: {{ arvados.shell.shellinabox.config }}
    - source: {{ files_switch(['shell-shellinabox.tmpl.jinja'],
                              lookup='arvados-shell-config-file-shellinabox-file-managed',
                              use_subpath=True
                 )
              }}
    - mode: 644
    - user: root
    - group: root
    - makedirs: true
    - template: jinja
    - require:
      - sls: {{ sls_package_install }}
    - context:
        arvados: {{ arvados | json }}

arvados-shell-config-file-pam-shellinabox-file-managed:
  file.managed:
    - name: /etc/pam.d/shellinabox
    - source: {{ files_switch(['shell-pam-shellinabox.tmpl.jinja'],
                              lookup='arvados-shell-config-file-pam-shellinabox-file-managed',
                              use_subpath=True
                 )
              }}
    - mode: 644
    - user: root
    - group: root
    - makedirs: true
    - template: jinja
    - require:
      - sls: {{ sls_package_install }}
    - context:
        arvados: {{ arvados | json }}

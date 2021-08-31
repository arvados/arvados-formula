# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import arvados with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

{%- do arvados.cluster.Users.update({'AnonymousUserToken': arvados.cluster.tokens.anonymous_user })
    if arvados.cluster.Users.AnonymousUserToken is not defined %}

include:
  - .package

arvados-config-file-file-managed:
  file.managed:
    - name: {{ arvados.config.file }}
    - source: {{ files_switch(['config.tmpl', 'config.tmpl.jinja'],
                              lookup='arvados-config-file-file-managed'
                 )
              }}
    - mode: {{ arvados.config.mode }}
    - user: {{ arvados.config.user }}
    - group: {{ arvados.config.group }}
    - makedirs: True
    - template: jinja
    - context:
        arvados: {{ arvados | json }}
    - check_cmd: {{ arvados.config.check_command }}
    - require:
      - pkg: arvados-config-package-install-pkg-installed

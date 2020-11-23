# -*- coding: utf-8 -*-
# vim: ft=yaml
---
# The variables commented out are the default values that the formula uses.
# The uncommented values are REQUIRED values. If you don't set them, running
# this formula will fail.
arvados:
  ### GENERAL CONFIG
  # version: '2.0.4'
  ## It makes little sense to disable this flag, but you can, if you want :)
  # use_upstream_repo: true

  ## Repo URL is built with grains values. If desired, it can be completely
  ## overwritten with the pillar parameter 'repo_url'
  # repo:
  #   humanname: Arvados Official Repository

  ## IMPORTANT!!!!!
  ## api, workbench and shell require some gems, so you need to make sure ruby
  ## and deps are installed in order to install and compile the gems.
  ## We default to `false` in these two variables as it's expected you already
  ## manage OS packages with some other tool and you don't want us messing up
  ## with your setup.
  ruby:
    ## We set these to `true` here for testing purposes.
    ## They both default to `false`.
    manage_ruby: true
    manage_gems_deps: true

  ### ARVADOS CLUSTER CONFIG
  cluster:
    name: fixme
    domain: example.net

    database:
      # max concurrent connections per arvados server daemon
      # connection_pool_max: 32
      name: arvados
      host: 127.0.0.1
      password: changeme_arvados
      user: arvados
      encoding: en_US.utf8
      client_encoding: UTF8
      # Centos7 does not enable SSL by default, so we disable
      # it here just for testing of the formula purposes only.
      # You should not do this in production, and should
      # configure Postgres certificates correctly
      {%- if grains.os_family in ('RedHat',) %}
      extra_conn_params:
        sslmode: disable
      {%- endif %}

    tls:
      # certificate: ''
      # key: ''
      # required to test with snakeoil certs
      insecure: true

    ### TOKENS
    tokens:
      system_root: changemesystemroottoken
      management: changememanagementtoken
      rails_secret: changemerailssecrettoken
      anonymous_user: changemeanonymoususertoken

    ### KEYS
    secrets:
      blob_signing_key: changemeblobsigningkey
      workbench_secret_key: changemeworkbenchsecretkey
      dispatcher_access_key: changemedispatcheraccesskey
      dispatcher_secret_key: changemedispatchersecretkey
      keep_access_key: changemekeepaccesskey
      keep_secret_key: changemekeepsecretkey

    AuditLogs:
      Section_to_ignore:
        - some_random_value

    ### VOLUMES
    ## This should usually match all your `keepstore` instances
    Volumes:
      # the volume name will be composed with
      # <cluster>-nyw5e-<volume>
      fixme-nyw5e-000000000000000:
        AccessViaHosts:
          http://keep0.fixme.example.net:25107:
            ReadOnly: false
        Replication: 2
        Driver: Directory
        DriverParameters:
          Root: /tmp

    Users:
      NewUsersAreActive: true
      AutoAdminFirstUser: true
      AutoSetupNewUsers: true
      AutoSetupNewUsersWithRepository: true

    Services:
      Controller:
        ExternalURL: https://fixme.example.net
        InternalURLs:
          http://controller.internal:8003: {}
      DispatchCloud:
        InternalURLs:
          http://fixme.example.net:9006: {}
      Keepbalance:
        InternalURLs:
          http://fixme.example.net:9005: {}
      Keepproxy:
        ExternalURL: https://keep.fixme.example.net
        InternalURLs:
          http://keep.internal:25100: {}
      Keepstore:
        InternalURLs:
          http://keep0.fixme.example.net:25107: {}
      RailsAPI:
        InternalURLs:
          http://api.internal:8004: {}
      WebDAV:
        ExternalURL: https://collections.fixme.example.net
        InternalURLs:
          http://collections.internal:9002: {}
      WebDAVDownload:
        ExternalURL: https://download.fixme.example.net
      WebShell:
        ExternalURL: https://webshell.fixme.example.net
      Websocket:
        ExternalURL: wss://ws.fixme.example.net/websocket
        InternalURLs:
          http://ws.internal:8005: {}
      Workbench1:
        ExternalURL: https://workbench.fixme.example.net
      Workbench2:
        ExternalURL: https://workbench2.fixme.example.net

# frozen_string_literal: true

users_stanza = <<-USERS_STANZA
    Users:
      AnonymousUserToken: anonymoususertokensetinthetokensdict
USERS_STANZA

api_stanza = <<-API_STANZA
    API:
API_STANZA

rails_stanza = <<-RAILS_STANZA
      RailsAPI:
        InternalURLs:
          http://api.internal:8004: {}
RAILS_STANZA

database_stanza = <<-DATABASE_STANZA
    ### DATABASE CONFIGURATION
    PostgreSQL:
      ConnectionPool: 32
      Connection:
        # All parameters here are passed to the PG client library in a connection string;
        # see https://www.postgresql.org/docs/current/static/libpq-connect.html#LIBPQ-PARAMKEYWORDS
        dbname: arvados
        host: 127.0.0.1
        password: "changeme_arvados"
        user: arvados
        client_encoding: UTF8
DATABASE_STANZA

group = case os[:name]
        when 'centos'
          'nginx'
        when 'debian', 'ubuntu'
          'www-data'
        end

control 'arvados configuration' do
  title 'should match desired api lines'

  describe file('/etc/arvados/config.yml') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into group }
    its('mode') { should cmp '0640' }
    its('content') do
      should include(
        'File managed by Salt at <salt://arvados/files/default/config.tmpl.jinja>.'
      )
    end
    its('content') { should include(api_stanza) }
    its('content') { should include(rails_stanza) }
    its('content') { should include(database_stanza) }
    its('content') { should include(users_stanza) }
  end
end

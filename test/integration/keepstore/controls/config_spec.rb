# frozen_string_literal: true

users_stanza = <<-USERS_STANZA
    Users:
      AnonymousUserToken: anonymoususertokensetintheusersdict
USERS_STANZA

keepstore_stanza = <<-KEEPSTORE_STANZA
      Keepstore:
        InternalURLs:
          http://keep0.fixme.example.net:25107: {}
KEEPSTORE_STANZA

volumes_stanza = <<-VOLUMES_STANZA
    Volumes:
      fixme-nyw5e-000000000000000:
        AccessViaHosts:
          http://keep0.fixme.example.net:25107:
            ReadOnly: false
        Driver: Directory
        DriverParameters:
          Root: /tmp
        Replication: 2
VOLUMES_STANZA

control 'arvados configuration' do
  title 'should match desired keepstore lines'

  describe file('/etc/arvados/config.yml') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    its('mode') { should cmp '0640' }
    its('content') do
      should include(
        'File managed by Salt at <salt://arvados/files/default/config.tmpl.jinja>.'
      )
    end
    its('content') { should include(keepstore_stanza) }
    its('content') { should include(volumes_stanza) }
    its('content') { should include(users_stanza) }
  end
end

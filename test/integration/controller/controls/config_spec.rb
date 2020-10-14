# frozen_string_literal: true

controller_stanza = <<-CONTROLLER_STANZA
      Keepstore:
        InternalURLs:
          http://keep0.fixme.example.net:25107: {}
CONTROLLER_STANZA

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
  title 'should match desired controller lines'

  describe file('/etc/arvados/config.yml') do
    it { should be_file }
    it { should be_owned_by 'root' }
    # We're testing it in the API instance, so group will be nginx's
    it { should be_grouped_into 'www-data' }
    its('mode') { should cmp '0640' }
    its('content') do
      should include(
        'File managed by Salt at <salt://arvados/files/default/config.tmpl.jinja>.'
      )
    end
    its('content') { should include(controller_stanza) }
    its('content') { should include(volumes_stanza) }
  end
end

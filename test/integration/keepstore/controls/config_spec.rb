# frozen_string_literal: true

keepstore_stanza = <<-KEEPSTORE_STANZA
      Keepstore:
        InternalURLs:
          "http://keep0.example.net:25107/": {}
KEEPSTORE_STANZA

volumes_stanza = <<-VOLUMES_STANZA
    Volumes:
      ### VOLUME_ONE
      fixme-nyw5e-000000000000000:
        Driver: Directory
        DriverParameters: {Root: /tmp}
        AccessViaHosts: {'http://keep0.example.net:25107/': {}}
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
  end
end

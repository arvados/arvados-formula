# frozen_string_literal: true

keepproxy_stanza = <<-KEEPPROXY_STANZA
      Keepstore:
        InternalURLs:
          "http://keep0.example.net:25107/": {}
KEEPPROXY_STANZA

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
  title 'should match desired keepproxy lines'

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
    its('content') { should include(keepproxy_stanza) }
    its('content') { should include(volumes_stanza) }
  end
end

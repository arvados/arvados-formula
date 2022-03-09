# frozen_string_literal: true

keepbalance_stanza = <<-KEEPBALANCE_STANZA
      Keepbalance:
        InternalURLs:
          http://fixme.example.net:9005: {}
KEEPBALANCE_STANZA

collections_stanza = <<-COLLECTIONS_STANZA
    Collections:
      BlobSigningKey: "blobsigningkeymushaveatleast32characters"
      BlobTrash: true
COLLECTIONS_STANZA

group = case os[:name]
        when 'centos'
          'nginx'
        when 'debian', 'ubuntu'
          'www-data'
        end

control 'arvados configuration' do
  title 'should match desired keepbalance lines'

  describe file('/etc/arvados/config.yml') do
    it { should be_file }
    it { should be_owned_by 'root' }
    # We're testing it in the API instance, so group will be nginx's
    it { should be_grouped_into group }
    its('mode') { should cmp '0640' }
    its('content') do
      should include(
        'File managed by Salt at <salt://arvados/files/default/config.tmpl.jinja>.'
      )
    end
    its('content') { should include(keepbalance_stanza) }
    its('content') { should include(collections_stanza) }
  end
end

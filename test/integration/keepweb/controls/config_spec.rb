# frozen_string_literal: true

keepweb_stanza = <<-KEEPWEB_STANZA
      WebDAV:
        ExternalURL: https://collections.fixme.example.net
        InternalURLs:
          http://collections.internal:9002: {}
      WebDAVDownload:
        ExternalURL: https://download.fixme.example.net
KEEPWEB_STANZA

group = case os[:name]
        when 'centos'
          'nginx'
        when 'debian', 'ubuntu'
          'www-data'
        end

control 'arvados configuration' do
  title 'should match desired keepweb lines'

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
    its('content') { should include(keepweb_stanza) }
  end
end

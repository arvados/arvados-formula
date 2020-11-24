# frozen_string_literal: true

api_stanza = <<-API_STANZA
    API:
      RailsSessionSecretToken: "changemerailssecrettoken"
API_STANZA

rails_stanza = <<-RAILS_STANZA
      RailsAPI:
        InternalURLs:
          http://api.internal:8004: {}
RAILS_STANZA

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
  end
end

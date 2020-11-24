# frozen_string_literal: true

workbench_config = <<-WORKBENCH_STANZA
    Workbench:
      SecretKeyBase: "changemeworkbenchsecretkey"
      SiteName: FIXME
WORKBENCH_STANZA

workbench_service = <<-WORKBENCH_SERVICE_STANZA
      Workbench1:
        ExternalURL: https://workbench.fixme.example.net
WORKBENCH_SERVICE_STANZA

group = case os[:name]
        when 'centos'
          'nginx'
        when 'debian', 'ubuntu'
          'www-data'
        end

control 'arvados configuration' do
  title 'should match desired workbench lines'

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
    its('content') { should include(workbench_config) }
    its('content') { should include(workbench_service) }
  end
end

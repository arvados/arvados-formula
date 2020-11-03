# frozen_string_literal: true

control 'arvados workbench service' do
  impact 0.5
  title 'should be running and enabled'

  describe systemd_service('nginx') do
    it { should be_enabled }
    it { should be_running }
  end

  describe port(9000) do
    proc = case os[:name]
           when 'centos'
             # Centos ps adds an extra colon and the end of the process
             # probably a bug
             'nginx:'
           when 'debian', 'ubuntu'
             'nginx'
           end

    it { should be_listening }
    its('processes') { should cmp proc }
  end
end

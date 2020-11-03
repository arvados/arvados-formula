# frozen_string_literal: true

control 'arvados controller service' do
  impact 0.5
  title 'should be running and enabled'

  describe service('arvados-controller') do
    it { should be_enabled }
    it { should be_running }
  end
  describe port(8003) do
    proc = case os[:name]
           when 'centos'
             'arvados-contr'
           when 'debian', 'ubuntu'
             'arvados-control'
           end

    it { should be_listening }
    # The undelying tools inspec uses to get the process truncates their names
    its('processes') { should cmp proc }
  end
end

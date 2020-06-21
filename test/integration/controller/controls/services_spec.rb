# frozen_string_literal: true

control 'arvados controller service' do
  impact 0.5
  title 'should be running and enabled'

  describe service('arvados-controller') do
    it { should be_enabled }
    it { should be_running }
  end
  describe port(8003) do
    it { should be_listening }
    # The undelying tools inspec uses to get the process truncates their names
    its('processes') { should include 'arvados-control' }
  end
end

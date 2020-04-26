# frozen_string_literal: true

control 'arvados controller service' do
  impact 0.5
  title 'should be running and enabled'

  describe service('keep-web') do
    it { should be_enabled }
    it { should be_running }
  end
  describe port(9002) do
    it { should be_listening }
    its('processes') { should include 'keep-web' }
  end
end

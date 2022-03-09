# frozen_string_literal: true

control 'arvados keepbalance service' do
  impact 0.5
  title 'should be running and enabled'

  describe service('keep-balance') do
    it { should be_enabled }
    it { should be_running }
  end
  describe port(9_005) do
    it { should be_listening }
    its('processes') { should cmp 'keep-balance' }
  end
end

# frozen_string_literal: true

control 'arvados keepproxy service' do
  impact 0.5
  title 'should be running and enabled'

  describe service('keepproxy') do
    it { should be_enabled }
    it { should be_running }
  end
  describe port(25_107) do
    it { should be_listening }
    its('processes') { should include 'keepproxy' }
  end
end

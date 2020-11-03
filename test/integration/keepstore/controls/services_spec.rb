# frozen_string_literal: true

control 'arvados keepstore service' do
  impact 0.5
  title 'should be running and enabled'

  describe service('keepstore') do
    it { should be_enabled }
    it { should be_running }
  end
  describe port(25_107) do
    it { should be_listening }
    its('processes') { should cmp 'keepstore' }
  end
end

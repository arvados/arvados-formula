# frozen_string_literal: true

control 'arvados api service' do
  impact 0.5
  title 'should be running and enabled'

  describe service('nginx') do
    it { should be_enabled }
    it { should be_running }
  end

  describe port(8004) do
    it { should be_listening }
    its('processes') { should include 'nginx' }
  end
end

# frozen_string_literal: true

control 'arvados websocket service' do
  impact 0.5
  title 'should be running and enabled'

  describe service('arvados-ws') do
    it { should be_enabled }
    it { should be_running }
  end

  describe port(8005) do
    it { should be_listening }
    its('processes') { should cmp 'arvados-ws' }
  end
end

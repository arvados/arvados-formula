# frozen_string_literal: true

control 'arvados shellinabox service' do
  impact 0.5
  title 'should be running and enabled'

  describe service('shellinabox') do
    it { should be_enabled }
    it { should be_running }
  end

  describe port(4200) do
    it { should be_listening }
    its('processes') { should include 'shellinaboxd' }
  end
end

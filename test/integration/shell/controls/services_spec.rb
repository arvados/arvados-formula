# frozen_string_literal: true

control 'arvados shellinabox service' do
  impact 0.5
  title 'should be running and enabled'

  serv = case os[:name]
         when 'centos'
           'shellinaboxd'
         when 'debian', 'ubuntu'
           'shellinabox'
         end

  describe service(serv) do
    it { should be_enabled }
    it { should be_running }
  end

  describe port(4200) do
    it { should be_listening }
    its('processes') { should cmp 'shellinaboxd' }
  end
end

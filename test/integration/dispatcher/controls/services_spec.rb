# frozen_string_literal: true

control 'arvados dispatcher service' do
  impact 0.5
  title 'should be running and enabled'

  describe service('crunch-dispatch-local') do
    it { should be_enabled }
    it { should be_running }
  end
end

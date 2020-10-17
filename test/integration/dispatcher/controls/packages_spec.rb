# frozen_string_literal: true

control 'arvados dispatcher package' do
  title 'should be installed'

  describe package('crunch-dispatch-local') do
    it { should be_installed }
  end
end

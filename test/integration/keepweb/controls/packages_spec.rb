# frozen_string_literal: true

control 'arvados keepweb package' do
  title 'should be installed'

  describe package('keep-web') do
    it { should be_installed }
  end
end

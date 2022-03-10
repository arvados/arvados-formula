# frozen_string_literal: true

control 'arvados keepbalance package' do
  title 'should be installed'

  describe package('keep-balance') do
    it { should be_installed }
  end
end

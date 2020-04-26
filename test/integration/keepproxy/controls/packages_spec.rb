# frozen_string_literal: true

control 'arvados keepproxy package' do
  title 'should be installed'

  describe package('keepproxy') do
    it { should be_installed }
  end
end

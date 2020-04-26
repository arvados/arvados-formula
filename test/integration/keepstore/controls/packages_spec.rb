# frozen_string_literal: true

control 'arvados keepstore package' do
  title 'should be installed'

  describe package('keepstore') do
    it { should be_installed }
  end
end

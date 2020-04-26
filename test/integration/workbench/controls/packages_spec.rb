# frozen_string_literal: true

control 'arvados workbench package' do
  title 'should be installed'

  describe package('arvados-workbench') do
    it { should be_installed }
  end
end

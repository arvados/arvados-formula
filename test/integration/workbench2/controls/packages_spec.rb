# frozen_string_literal: true

control 'arvados workbench2 package' do
  title 'should be installed'

  describe package('arvados-workbench2') do
    it { should be_installed }
  end
end

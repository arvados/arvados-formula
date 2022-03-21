# frozen_string_literal: true

control 'ruby bundler package' do
  title 'should not be installed'

  describe package('ruby-bundler') do
    it { should_not be_installed }
  end
  describe package('bundler') do
    it { should_not be_installed }
  end
end

control 'arvados workbench package' do
  title 'should be installed'

  describe package('arvados-workbench') do
    it { should be_installed }
  end
end

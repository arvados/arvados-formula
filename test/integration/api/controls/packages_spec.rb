# frozen_string_literal: true

# Copyright (C) The Arvados Authors. All rights reserved.
#
# SPDX-License-Identifier: Apache-2.0

control 'arvados api package' do
  title 'should be installed'

  describe package('arvados-api-server') do
    it { should be_installed }
  end
end

control 'RVM dependencies' do
  title 'should be installed'

  only_if("Forced requirement for RedHat's family") do
    os.redhat?
  end

  %w[
    centos-release-scl
    curl
    gcc
    git
    libcurl
    libcurl-devel
    libxml2
    libxml2-devel
    make
    pam-devel
    postgresql12-libs
    python3-devel
    zlib-devel
  ].each do |p|
    describe package(p) do
      it { should be_installed }
    end
  end
end

control 'RVM ruby manager' do
  title 'should be installed'

  only_if('Forced requirement for Centos-7 and Ubuntu-18.04') do
    (os.redhat? and platform[:release].to_f.truncate == 7) or
      (os.name == 'ubuntu' and platform[:release].to_f.truncate == 18)
  end

  describe command('/usr/local/rvm/bin/rvm list') do
    its(:exit_status) { should eq 0 }
    its('stdout') { should match(/ruby-2.7.2/) }
  end
end

control 'arvados cli gem' do
  title 'should be installed'

  only_if('Skipped in Centos-7 and Ubuntu-18.04') do
    !((os.redhat? and platform[:release].to_f.truncate == 7) or
    (os.name == 'ubuntu' and platform[:release].to_f.truncate == 18))
  end

  describe gem('arvados-cli') do
    it { should be_installed }
  end
end

control 'RVM arvados cli gem' do
  title 'should be installed'

  only_if('Forced requirement for Centos-7 and Ubuntu-18.04') do
    (os.redhat? and platform[:release].to_f.truncate == 7) or
      (os.name == 'ubuntu' and platform[:release].to_f.truncate == 18)
  end

  describe gem('arvados-cli', '/usr/local/rvm/bin/rvm all do gem') do
    it { should be_installed }
  end
end

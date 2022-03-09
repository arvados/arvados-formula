# Copyright (C) The Arvados Authors. All rights reserved.
#
# SPDX-License-Identifier: Apache-2.0
# frozen_string_literal: true

packages_list = %w[
  arvados-client
  arvados-src
  python3-arvados-fuse
  python3-arvados-python-client
  python3-arvados-cwl-runner
  python3-crunchstat-summary
  shellinabox
]

gems_list = %w[
  arvados-cli
  arvados-login-sync
]

control 'arvados shell packages' do
  title 'should be installed'

  packages_list.each do |p|
    describe package(p) do
      it { should be_installed }
    end
  end
end

control 'arvados shell gems' do
  title 'should be installed'

  gems_list.each do |p|
    describe gem(p) do
      it { should be_installed }
    end
  end
end

control 'arvados shell gems' do
  title 'should be installed'

  only_if('Skipped in Centos-7, Ubuntu-18.04 and Debian-10') do
    !((os.redhat? and platform[:release].to_f.truncate == 7) or
    (os.name == 'ubuntu' and platform[:release].to_f.truncate == 18) or
    (os.name == 'debian' and platform[:release].to_f.truncate == 10))
  end

  describe gem('arvados-cli') do
    it { should be_installed }
  end
end

control 'RVM arvados shell gems' do
  title 'should be installed'

  only_if('Forced requirement for Centos-7, Ubuntu-18.04 and Debian-10') do
    (os.redhat? and platform[:release].to_f.truncate == 7) or
      (os.name == 'ubuntu' and platform[:release].to_f.truncate == 18) or
      (os.name == 'debian' and platform[:release].to_f.truncate == 10)
  end

  describe gem('arvados-cli', '/usr/local/rvm/bin/rvm all do gem') do
    it { should be_installed }
  end
end

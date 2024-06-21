# Copyright (C) The Arvados Authors. All rights reserved.
#
# SPDX-License-Identifier: Apache-2.0

# frozen_string_literal: true

case os[:name]
when 'centos'
  repo_file = '/etc/yum.repos.d/arvados.repo'
  repo_url = 'baseurl=http://rpm.arvados.org/RHEL/$releasever/dev/$basearch/'
when 'debian', 'ubuntu'
  # Inspec does not provide a `codename` matcher, so we add ours
  case platform[:release].to_f.truncate
  # ubuntu
  when 18
    codename = 'bionic'
  when 20
    codename = 'focal'
  # debian
  when 10
    codename = 'buster'
  when 11
    codename = 'bullseye'
  end
  repo_file = '/etc/apt/sources.list.d/arvados.list'
  repo_keyring = '/usr/share/keyrings/arvados-archive-keyring.gpg'
  repo_url = "deb [signed-by=/usr/share/keyrings/arvados-archive-keyring.gpg arch=amd64] http://apt.arvados.org/#{codename} #{codename}-dev main"
end

control 'arvados repository keyring' do
  title 'should be installed'

  only_if('Requirement for Debian family') do
    platform.family == 'debian'
  end

  describe file(repo_keyring) do
    it { should exist }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    its('mode') { should cmp '0644' }
  end
end

control 'arvados repository' do
  impact 1
  title 'should be configured'
  desc 'Ensures arvados source is correctly configured'
  describe file(repo_file) do
    its('content') { should include repo_url }
  end
end

# Copyright (C) The Arvados Authors. All rights reserved.
#
# SPDX-License-Identifier: Apache-2.0

# frozen_string_literal: true

case os[:name]
when 'centos'
  repo_file = '/etc/yum.repos.d/arvados.repo'
  repo_url = 'baseurl=http://rpm.arvados.org/CentOS/$releasever/os/$basearch/'
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
  repo_url = "deb http://apt.arvados.org/#{codename} #{codename} main"
end

control 'arvados repository' do
  impact 1
  title 'should be configured'
  desc 'Ensures arvados source is correctly configured'
  describe file(repo_file) do
    its('content') { should include repo_url }
  end
end

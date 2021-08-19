# frozen_string_literal: true

# Copyright (C) The Arvados Authors. All rights reserved.
#
# SPDX-License-Identifier: Apache-2.0

case os[:name]
when 'centos'
  repo_file = '/etc/yum.repos.d/arvados.repo'
  repo_url = 'baseurl=http://rpm.arvados.org/CentOS/$releasever/os/$basearch/'
when 'debian'
  repo_file = '/etc/apt/sources.list.d/arvados.list'
  repo_url = 'deb http://apt.arvados.org/buster buster main'
when 'ubuntu'
  repo_file = '/etc/apt/sources.list.d/arvados.list'
  repo_url = case platform[:release].to_f.truncate
             when 20
               'focal'
             when 18
               'bionic'
             when 16
               'xenial'
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

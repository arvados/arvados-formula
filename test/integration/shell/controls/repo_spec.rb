# frozen_string_literal: true

case os[:name]
when 'centos'
  repo_file = '/etc/yum.repos.d/arvados.repo'
  repo_url = 'baseurl=http://rpm.arvados.org/CentOS/$releasever/dev/$basearch/'
when 'debian', 'ubuntu'
  repo_file = '/etc/apt/sources.list.d/arvados.list'
  repo_url = 'deb http://apt.arvados.org/buster buster-dev main'
end

control 'arvados repository' do
  impact 1
  title 'should be configured'
  desc 'Ensures arvados source is correctly configured'
  describe file(repo_file) do
    its('content') { should include repo_url }
  end
end

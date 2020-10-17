# frozen_string_literal: true

control 'arvados dispatcher service' do
  impact 0.5
  title 'files should exist'

  describe file('/usr/local/bin/crunch-run.sh') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    its('mode') { should cmp '0755' }
    its('content') do
      should include(
        # rubocop:disable Metrics/LineLength
        'File managed by Salt at <salt://arvados/dispatcher/service/files/default/crunch-run-sh.tmpl>.'
        # rubocop:enable Metrics/LineLength
      )
    end
  end
  describe file('/etc/systemd/system/crunch-dispatch-local.service') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    its('mode') { should cmp '0644' }
    its('content') do
      should include(
        # rubocop:disable Metrics/LineLength
        'File managed by Salt at <salt://arvados/dispatcher/service/files/default/crunch-dispatch-local-service.tmpl>.'
        # rubocop:enable Metrics/LineLength
      )
    end
  end
end

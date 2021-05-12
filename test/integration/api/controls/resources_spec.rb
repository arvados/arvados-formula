# frozen_string_literal: true

test_cmd = <<~TEST_CMD
  su -l kitchen -c \
    "ARVADOS_API_TOKEN=\\"systemroottokenmushaveatleast32characters\\" \
    ARVADOS_API_HOST=\\"fixme.example.net\\" \
    arv virtual_machine list --filters '[[\\"hostname\\", \\"=\\", \\"%s\\"]]'"
TEST_CMD

control 'arvados api resources' do
  impact 0.5
  title 'should be created'

  %w[
    webshell1
    webshell2
  ].each do |vm|
    describe "virtual machine #{vm}" do
      subject do
        command(test_cmd % vm)
      end
      its('stdout') { should match(/"uuid":"fixme-2x53u-[a-z0-9_]{15}"/) }
      its('stdout') { should match(/"hostname":"#{vm}"/) }
      its('stderr') { should eq '' }
      its('exit_status') { should eq 0 }
    end
  end
end

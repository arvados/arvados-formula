# frozen_string_literal: true

query_virtual_machines = <<~TEST_VM_CMD
  su -l kitchen -c \
    "ARVADOS_API_TOKEN=\\"systemroottokenmushaveatleast32characters\\" \
    ARVADOS_API_HOST=\\"fixme.example.net\\" \
    arv virtual_machine list --filters '[[\\"hostname\\", \\"=\\", \\"%s\\"]]'"
TEST_VM_CMD

query_scoped_token_urls = <<~TEST_STU_CMD
  su -l kitchen -c \
    "ARVADOS_API_TOKEN=\\"systemroottokenmushaveatleast32characters\\" \
    ARVADOS_API_HOST=\\"fixme.example.net\\" \
    arv api_client_authorization list"
TEST_STU_CMD

control 'arvados api resources' do
  impact 0.5
  title 'should be created'

  %w[
    webshell1
    webshell2
    webshell3
  ].each do |vm|
    describe "virtual machine #{vm}" do
      subject do
        command(query_virtual_machines % vm)
      end
      its('stdout') { should match(/"uuid":"fixme-2x53u-[a-z0-9_]{15}"/) }
      its('stdout') { should match(/"hostname":"#{vm}"/) }
      its('stderr') { should eq '' }
      its('exit_status') { should eq 0 }
    end

    describe "scoped token for #{vm}" do
      subject do
        command(query_scoped_token_urls % vm)
      end
      its('stdout') do
        should match(
          %r{"GET /arvados/v1/virtual_machines/fixme-2x53u-[a-z0-9]{15}/logins"}
        )
      end
      its('stderr') { should eq '' }
      its('exit_status') { should eq 0 }
    end
  end
end

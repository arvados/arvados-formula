# frozen_string_literal: true

packages_list = %w[
  arvados-client
  arvados-src
  libpam-arvados
  python-arvados-fuse
  python-arvados-python-client
  python3-arvados-cwl-runner
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

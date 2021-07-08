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

control 'arvados cli gem' do
  title 'should be installed'

  describe gem('arvados-cli') do
    it { should be_installed }
  end
end

control 'RVM and dependencies' do
  title 'should be installed'

  only_if("Forced requirement for RedHat's family") do
    os.redhat?
  end

  %w[
    rubygem-bundler
    curl
    gcc
    git
    libcurl
    libcurl-devel
    pam-devel
    postgresql-devel
    libxml2
    libxml2-devel
    make
    python3-devel
    ruby-devel
    zlib-devel
  ].each do |p|
    describe package(p) do
      it { should be_installed }
    end
  end
end

# frozen_string_literal: true

# Copyright (C) The Arvados Authors. All rights reserved.
#
# SPDX-License-Identifier: Apache-2.0

control 'ruby bundler package' do
  title 'should not be installed'

  describe package('ruby-bundler') do
    it { should_not be_installed }
  end
  describe package('bundler') do
    it { should_not be_installed }
  end
end

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

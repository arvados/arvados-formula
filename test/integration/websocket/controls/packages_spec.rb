# frozen_string_literal: true

control 'arvados websocket package' do
  title 'should be installed'

  describe package('arvados-ws') do
    it { should be_installed }
  end
end

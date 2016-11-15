require 'spec_helper'
describe 'backup' do
  context 'with default values for all parameters' do
    it { should contain_class('backup') }
    it { should contain_class('backup::install') }
    it { should contain_class('backup::config') }
    it { should create_file('/etc/backup/config.rb').with(
      :owner => 'root',
      :group => 'root',
      :mode  => '0440',
    )}
  end
end

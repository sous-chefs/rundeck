require File.expand_path('../support/helpers', __FILE__)


describe 'rsync::server' do
  include Test::Rsync
  
  it 'installs rsync' do
    package('rsync').must_be_installed
  end

  it 'creates an init script' do
    rsyncd_config.must_exist
  end

  it 'defines the service' do 
    rsyncd_service.must_exist
  end
end


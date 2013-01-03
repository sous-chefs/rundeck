require File.expand_path('../support/helpers', __FILE__)


describe 'rsync::lwrp_test' do
  include  Test::Rsync
 
  it 'starts rsyncd' do 
    rsyncd_service.must_be_running
  end
  
  it 'enables rsyncd' do 
    rsyncd_service.must_be_enabled
  end

  it 'creates config file' do 
    rsyncd_config.must_exist
  end

  it 'serves test files' do
    serving? "test"
  end

end

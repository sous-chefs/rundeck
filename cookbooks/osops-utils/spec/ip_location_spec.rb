require 'chefspec'
require "#{File.dirname(File.dirname(__FILE__))}/libraries/ip_location"

describe 'RCB' do
  let(:rcb) { Object.new.extend(RCB) }
  describe '#rcb_safe_deref' do
    it 'should return nil if key not in path' do
      hash = { 'a' => { 'b' => 'b' } }
      path = 'b'
      rcb.rcb_safe_deref(hash, path).should == nil
    end
    it 'should return string if key in path' do
      hash = { 'a' => { 'b' => 'b' } }
      path = 'a.b'
      rcb.rcb_safe_deref(hash, path).should == 'b'
      hash = { 'a' => { 'b' => { 'c' => 'c' } } }
      path = 'a.b.c'
      rcb.rcb_safe_deref(hash, path).should == 'c'
    end
    it 'should return hash if key in path' do
      hash = { 'a' => { 'b' => 'b' } }
      path = 'a'
      rcb.rcb_safe_deref(hash, path).should == { 'b' => 'b' }
    end
  end
  describe '#get_config_endpoint' do
    it 'should return nil if nodeish empty' do
      server = 'server'
      service = 'service'
      nodeish = { }
      rcb.get_config_endpoint(server, service, nodeish).should == nil
    end
    it 'should return empty hash if nodeish empty and partial is true' do
      server = 'server'
      service = 'service'
      nodeish = { }
      rcb.get_config_endpoint(server, service, nodeish, partial=true).should == {}
    end
    it 'should return host and uri if nodeish contains host and no uri' do
      server = 'server'
      service = 'service'
      nodeish = { 'server' =>
                  { 'services' =>
                    { 'service' =>
                      {'host' => '1.1.1.1' }
                    }
                  }
                }
      result = rcb.get_config_endpoint(server, service, nodeish)
      result.should have_key("host")
      result["host"].should == '1.1.1.1'
      result.should have_key("uri")
      result["uri"].should == 'http://1.1.1.1:80/'
    end
    it 'should return host and uri if nodeish contains uri and host' do
      server = 'server'
      service = 'service'
      nodeish = { 'server' =>
                  { 'services' =>
                    { 'service' =>
                      { 'host' => '1.1.1.1',
                        'uri' => '1.1.1.1/do/not/change' 
                      }
                    }
                  }
                }
      result = rcb.get_config_endpoint(server, service, nodeish)
      result.should have_key("uri")
      result["uri"].should == '1.1.1.1/do/not/change'
      result.should have_key("host")
      result["host"].should == '1.1.1.1'
    end
    it 'should return host and uri if nodeish contains uri and no host' do
      server = 'server'
      service = 'service'
      nodeish = { 'server' =>
                  { 'services' =>
                    { 'service' =>
                      {'uri' => '1.1.1.1/do/not/change' }
                    }
                  }
                }
      result = rcb.get_config_endpoint(server, service, nodeish)
      result.should have_key("uri")
      result["uri"].should == '1.1.1.1/do/not/change'
      result.should have_key("host")
      result["host"].should == '1.1.1.1'
    end
  end
end

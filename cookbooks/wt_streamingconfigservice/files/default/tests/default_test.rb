class Wt_streamingconfigserviceTest < MiniTest::Chef::TestCase
  require 'net/http'
  require 'yajl'

  def test_healthcheck
    ago = Time.now
    begin 
      res = Net::HTTP.get(node['fqdn'],"/healthcheck",9000)
      status = Yajl::Parser.parse(res)
      status["checks"].each do |check, value|
        assert_equal 'true', value["healthy"]
      end
    rescue
      retry unless ago+15 < Time.now
      flunk "#{node['fqdn']}:9000/healthcheck did not respond within 15 seconds"
    end
  end
end

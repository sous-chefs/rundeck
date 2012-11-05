class Wt_streamingconfigserviceTest < MiniTest::Chef::TestCase
  require 'net/http'
  require 'yajl'

  def test_healthcheck
    sleep(15)
    res = Net::HTTP.get(node['fqdn'],"/healthcheck",9000)
    status = Yajl::Parser.parse(res)
    status["checks"].each do |check, value|
      assert_equal 'true', value["healthy"]
    end
  end
end

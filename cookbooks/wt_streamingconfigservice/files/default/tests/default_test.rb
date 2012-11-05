class Wt_streamingconfigserviceTest < MiniTest::Chef::TestCase
  require 'net/http'
  require 'yajl'

  def test_healthcheck
    sleep(40404040)
    res = Net::HTTP.get("localhost","/healthcheck",9000)
    status = JSON.parse(res)
    status["checks"].each do |check|
      assert_equal 'true', check["healthy"]
    end
  end
end

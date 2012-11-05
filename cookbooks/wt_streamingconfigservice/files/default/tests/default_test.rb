class Wt_streamingconfigserviceTest < MiniTest::Chef::TestCase
  require 'net/http'
  require 'yajl'

  def test_healthcheck
    res = Net::HTTP.get("localhost","/healthcheck",9000)
    status = JSON.parse(res)
    assert_equal 'true', status["checks"]["monitoring_healthcheck"]["healthy"]
  end
end

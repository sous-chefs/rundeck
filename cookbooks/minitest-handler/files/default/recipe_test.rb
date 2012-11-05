class DefaultTest < MiniTest::Chef::TestCase
  def test_succeed
    assert run_status.success?
  end
end

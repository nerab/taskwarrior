require 'test_helper'

class TestSetupTeardown < MiniTest::Unit::TestCase
  def test_setup
    assert_equal(0, %x[task count].chomp.to_i)
  end
end

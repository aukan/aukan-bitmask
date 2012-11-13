require File.dirname(__FILE__) + '/test_helper.rb'

class TestBitmask < Test::Unit::TestCase

  def setup
    @bitmask = Bitmask.new
  end

  def test_default_value_is_zero
    assert @bitmask.value == 0
  end
end

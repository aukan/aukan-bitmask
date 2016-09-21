require File.dirname(__FILE__) + '/test_helper.rb'

class TestBitmaskAttributeAccessors < Test::Unit::TestCase
  class Something
    attr_accessor :flags
    include BitmaskAttribute
    bitmask_attribute :flags,
      :bit_ids => [:flag1, :flag2],
      :accessors => true
  end

  def test_accessors
    @something = Something.new
    @something.flag1 = true
    assert @something.flags == 1
    assert @something.flag1
    assert @something.flag1?
    assert !@something.flag2
    assert !@something.flag2?
  end
end

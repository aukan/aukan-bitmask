require File.dirname(__FILE__) + '/test_helper.rb'

class TestBitmaskAttribute < Test::Unit::TestCase

  class Something
    attr_accessor :flags

    include BitmaskAttribute
    bitmask_attribute :flags, {
      :bit_ids => [:flag1, :flag2, :flag3]
    }
  end

  def setup
    @something = Something.new
  end

  def test_initialization_respects_the_attribute
    assert @something.flags == nil
  end

  def test_setting_a_flag_updates_the_attribute
    @something.flags_bitmask.set :flag1, true
    assert @something.flags == 1
  end

  def test_setting_the_value_updates_the_attribute
    @something.flags_bitmask.value = 3
    assert @something.flags == 3
  end

  def test_bit_ids
    assert @something.flags_bitmask.bit_ids == [:flag1, :flag2, :flag3]
  end

end

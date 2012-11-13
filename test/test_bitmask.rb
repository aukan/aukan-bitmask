require File.dirname(__FILE__) + '/test_helper.rb'

class TestBitmask < Test::Unit::TestCase

  def setup
    @bitmask = Bitmask.new({
      :bit_ids => [:flag1, :flag2, :flag3]
    })
  end

  def test_default_value_is_zero
    assert @bitmask.value == 0
  end

  def test_initializig_with_a_value
    @bitmask = Bitmask.new({
      :value => 3
    })
    assert @bitmask.value == 3
  end

  def test_initializing_with_bit_ids
    assert @bitmask.bit_ids == [:flag1, :flag2, :flag3]
  end

  def test_all_flags_are_false
    assert @bitmask.get(:flag1) == false
    assert @bitmask.get(:flag2) == false
    assert @bitmask.get(:flag3) == false
  end

  def test_raising_a_flag
    @bitmask.set(:flag1, true)
    assert @bitmask.get(:flag1) == true
  end

  def test_raising_all_flags_by_setting_the_value
    @bitmask.value = 7
    assert @bitmask.get(:flag2) == true
    assert @bitmask.get(:flag1) == true
    assert @bitmask.get(:flag3) == true
  end

  def test_after_change_event_on_set
    number = 0
    @bitmask.after_change = Proc.new { |bitmask| number = 5 }

    assert number == 0
    @bitmask.set :flag1, true
    assert number == 5
  end

  def test_after_change_on_initialization
    number = 0
    @bitmask = Bitmask.new({
      :after_change => Proc.new { |bitmask| number = 5 },
      :bit_ids => [:flag1]
    })

    assert number == 0
    @bitmask.set :flag1, true
    assert number == 5
  end

  def test_after_change_event_when_changing_value
    number = 0
    @bitmask.after_change = Proc.new { |bitmask| number = 5 }

    assert number == 0
    @bitmask.value = 1
    assert number == 5
  end
end

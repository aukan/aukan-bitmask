require File.dirname(__FILE__) + '/test_helper.rb'

class TestActiveRecord51 < Test::Unit::TestCase
  # stub ActiveRecord
  def setup
    Kernel.const_set(:ActiveRecord, Module.new)
    ::ActiveRecord.const_set("VERSION", Module.new)
    ::ActiveRecord::VERSION.const_set("MAJOR", 5)
    ::ActiveRecord::VERSION.const_set("STRING", "5.1.1")
    ::ActiveRecord.const_set("Type", Module.new)
    ::ActiveRecord::Type.const_set("Boolean", Class.new {
      def cast(val); val == "1"; end
    })
  end

  # remove the stub so we don't affect other tests
  def teardown
    Kernel.send(:remove_const, :ActiveRecord)
  end

  module StubActiveRecord
    def saved_change_to_attribute?(attr)
      if attr == :flags
        true
      else
        fail "Invalid AR call: #{attr}"
      end
    end

    def attribute_before_last_save(attr)
      if attr == :flags
        1
      else
        fail "Invalid AR call: #{attr}"
      end
    end
  end

  def class_with_active_record
    Class.new do
      include StubActiveRecord
      include BitmaskAttribute
      attr_accessor :flags
      bitmask_attribute :flags,
        :bit_ids => [:flag1, :flag2, :flag3]
    end
  end

  def class_with_active_record_and_accessors
    Class.new do
      include StubActiveRecord
      include BitmaskAttribute
      attr_accessor :flags
      bitmask_attribute :flags,
        :bit_ids => [:flag1, :flag2, :flag3],
        :accessors => true
    end
  end

  def test_before_last_save
    @something = class_with_active_record.new
    assert_equal(1, @something.flags_bitmask_before_last_save.value)
    assert_equal(true, @something.flags_bitmask_before_last_save[:flag1])
    assert_equal(false, @something.flags_bitmask_before_last_save[:flag2])
    assert_equal(false, @something.flags_bitmask_before_last_save[:flag3])
    assert_equal([:flag1, :flag2, :flag3], @something.flags_bitmask_before_last_save.bit_ids)
  end

  def test_saved_change_to_attribute
    @something = class_with_active_record_and_accessors.new
    @something.flags = 0
    assert @something.saved_change_to_flags_bitmask_attribute?(:flag1)
    assert !@something.saved_change_to_flags_bitmask_attribute?(:flag2)
    assert !@something.saved_change_to_flags_bitmask_attribute?(:flag3)
  end
end

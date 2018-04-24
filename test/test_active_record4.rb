require File.dirname(__FILE__) + '/test_helper.rb'

class TestActiveRecord4 < Test::Unit::TestCase
  # stub ActiveRecord
  def setup
    Kernel.const_set(:ActiveRecord, Module.new)
    ::ActiveRecord.const_set("VERSION", Module.new)
    ::ActiveRecord::VERSION.const_set("MAJOR", 4)
    ::ActiveRecord::VERSION.const_set("STRING", "4.2.0")
    ::ActiveRecord.const_set("Type", Module.new)
    ::ActiveRecord::Type.const_set("Boolean", Class.new {
      def type_cast_from_user(val); val == "1"; end
    })
  end

  # remove the stub so we don't affect other tests
  def teardown
    Kernel.send(:remove_const, :ActiveRecord)
  end

  module StubActiveRecord
    def flags_was
      1
    end

    def flags_changed?
      flags != flags_was
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

  def test_attribute_was
    @something = class_with_active_record.new
    assert_equal(1, @something.flags_bitmask_was.value)
    assert_equal([:flag1, :flag2, :flag3], @something.flags_bitmask_was.bit_ids)
  end

  def test_attribute_changed
    @something = class_with_active_record.new
    @something.flags = 0
    assert @something.flags_bitmask_changed?
    @something.flags = 1
    assert !@something.flags_bitmask_changed?
  end

  def test_accessor_attribute_was
    @something = class_with_active_record_and_accessors.new
    assert @something.flag1_was
    assert !@something.flag2_was
    assert !@something.flag3_was
  end

  def test_accessor_attribute_changed
    @something = class_with_active_record_and_accessors.new
    @something.flags = 0
    assert @something.flag1_changed?
    assert !@something.flag2_changed?
    assert !@something.flag3_changed?
  end

  def test_typecast
    @something = class_with_active_record_and_accessors.new
    assert !@something.flag1
    @something.flag1 = "1"
    @something.flag2 = "0"
    assert @something.flag1
    assert !@something.flag2
  end
end

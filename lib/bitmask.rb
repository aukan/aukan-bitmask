class Bitmask

  attr_accessor :bit_ids, :after_change
  attr_reader   :value, :string_bit_ids

  def initialize ( options = {} )
    default_values = {
      :value => 0,
      :bit_ids => []
    }
    options = default_values.merge(options)

    # Events
    @after_change = options[:after_change]

    @value   = options[:value].to_i
    @bit_ids = options[:bit_ids]
    @string_bit_ids = @bit_ids.map(&:to_s)
  end

  def get ( bit_id )
    position = @bit_ids.index( bit_id )

    if position == nil
      raise ArgumentError, "#{bit_id.inspect} was not included on bit_ids array"
    end

    (@value & (2 ** position)) > 0
  end
  alias :[] :get

  def set ( bit_id, val )
    position = @bit_ids.index( bit_id )

    if position == nil
      raise ArgumentError, "#{bit_id.inspect} was not included on bit_ids array"
    end

    if typecast_value(val)
      self.value |= (2 ** position)
    else
      self.value &= ~(2 ** position)
    end

    @after_change.call(self) if @after_change

    val
  end
  alias :[]= :set

  def value= ( val )
    @value = val
    @after_change.call(self) if @after_change
  end

  private

  def typecast_value(val)
    # Emulate the Rails typecast that happens in case the value originated from
    # a web form where the value is typically "0"/"1".
    case active_record_major_version
    when 5
      ::ActiveRecord::Type::Boolean.new.cast(val)
    when 4
      ::ActiveRecord::Type::Boolean.new.type_cast_from_user(val)
    when 3
      ::ActiveRecord::ConnectionAdapters::Column.value_to_boolean(val)
    else
      val # default is value truthiness
    end
  end

  def active_record_major_version
    return unless defined?(::ActiveRecord::VERSION::MAJOR)
    ::ActiveRecord::VERSION::MAJOR
  end
end

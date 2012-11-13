class Bitmask

  attr_accessor :value, :bit_ids, :after_change

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
  end

  def get ( bit_id )
    position = @bit_ids.index( bit_id )

    return (@value & (2 ** position)) > 0
  end

  def set ( bit_id, val )
    position = @bit_ids.index( bit_id )

    if val == true
      self.value |= (2 ** position)
    else
      self.value &= ~(2 ** position)
    end

    @after_change.call(self) if @after_change

    return self.value
  end

  def value= ( val )
    @value = val
    @after_change.call(self) if @after_change
  end

end

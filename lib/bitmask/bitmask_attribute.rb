module BitmaskAttribute

  def self.included (base)
    base.extend( ClassMethods )
  end

  module ClassMethods

    def bitmask_attribute ( attribute_name, options = {} )
      default_options = {
        :bitmask_object => attribute_name.to_s + '_bitmask',
        :bit_ids => []
      }
      options = default_options.merge(options)

      bitmask_obj = options[:bitmask_object]
      class_eval <<-ADD_METHOD
        def #{options[:bitmask_object]}
          @_#{options[:bitmask_object]} ||= Bitmask.new({
            :bit_ids => #{options[:bit_ids].inspect},
            :value => @#{attribute_name},
            :after_change => Proc.new { |bitmask|
              @#{attribute_name} = bitmask.value
            }
          })
        end
      ADD_METHOD

    end

  end

end

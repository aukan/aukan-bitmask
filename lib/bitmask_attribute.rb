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

      class_eval <<-ADD_METHODS
        def #{options[:bitmask_object]}
          @_#{options[:bitmask_object]} ||= Bitmask.new({
            :bit_ids => #{options[:bit_ids].inspect},
            :value => self.#{attribute_name},
            :after_change => Proc.new { |bitmask|
              self.#{attribute_name} = bitmask.value
            }
          })
        end

        def #{options[:bitmask_object]}= new_bitmask_hash
          new_bitmask_hash.each do |key, val|
            key = key.to_sym if #{options[:bitmask_object]}.string_bit_ids.include?(key)
            #{options[:bitmask_object]}[key] = val
          end
          #{options[:bitmask_object]}
        end
      ADD_METHODS

    end

  end

end

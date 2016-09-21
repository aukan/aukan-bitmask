module BitmaskAttribute

  def self.included (base)
    base.extend( ClassMethods )
  end

  module ClassMethods

    def bitmask_attribute ( attribute_name, options = {} )
      default_options = {
        :bitmask_object => "#{attribute_name}_bitmask",
        :bit_ids => []
      }
      options = default_options.merge(options)

      define_method(options[:bitmask_object]) do
        ivar_name = "@_#{options[:bitmask_object]}"
        if instance_variable_defined?(ivar_name)
          instance_variable_get(ivar_name)
        else
          instance_variable_set(ivar_name,
            Bitmask.new(
              :bit_ids => options[:bit_ids],
              :value => send(attribute_name),
              :after_change => Proc.new { |bitmask|
                send("#{attribute_name}=", bitmask.value)
              }
            )
          )
        end
      end

      define_method("#{options[:bitmask_object]}=") do |new_bitmask_hash|
        new_bitmask_hash.each do |key, val|
          key = key.to_sym if send(options[:bitmask_object]).string_bit_ids.include?(key)
          send(options[:bitmask_object])[key] = val
        end
        send(options[:bitmask_object])
      end

      if options[:accessors]
        options[:bit_ids].each do |attr|
          define_method(attr) do
            send(options[:bitmask_object])[attr]
          end
          alias_method "#{attr}?", attr

          define_method("#{attr}=") do |value|
            send(options[:bitmask_object])[attr] = value
          end
        end
      end

    end

  end

end

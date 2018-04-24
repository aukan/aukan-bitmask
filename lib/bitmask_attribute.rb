require File.dirname(__FILE__) + '/aukan-bitmask/active_record'

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

      # Emulate ActiveRecord dirty methods
      if ::AukanBitmask::ActiveRecord.enabled?
        define_method("#{options[:bitmask_object]}_was") do
          Bitmask.new(
            :bit_ids => options[:bit_ids],
            :value => send("#{attribute_name}_was")
          )
        end

        define_method("#{options[:bitmask_object]}_changed?") do
          send("#{attribute_name}_changed?")
        end

        if options[:accessors]
          options[:bit_ids].each do |attr|
            # Emulate ActiveRecord dirty methods for every attribute
            define_method("#{attr}_was") do
              send("#{options[:bitmask_object]}_was")[attr]
            end

            define_method("#{attr}_changed?") do
              send("#{attribute_name}_changed?") &&
                send("#{attr}_was") != send(attr)
            end
          end
        end

        if ::AukanBitmask::ActiveRecord.version_string >= "5.1"
          define_method("#{options[:bitmask_object]}_before_last_save") do
            Bitmask.new(
              :bit_ids => options[:bit_ids],
              :value => attribute_before_last_save(attribute_name)
            )
          end

          if options[:accessors]
            define_method("saved_change_to_#{options[:bitmask_object]}_attribute?") do |attr|
              saved_change_to_attribute?(attribute_name) &&
                send("#{options[:bitmask_object]}_before_last_save")[attr] != send(attr)
            end
          end
        end
      end

    end

  end

end

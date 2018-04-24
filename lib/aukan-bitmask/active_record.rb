module AukanBitmask
  class AukanBitmask::ActiveRecord
    def self.enabled?
      defined?(::ActiveRecord)
    end

    def self.major_version
      return unless enabled?
      ::ActiveRecord::VERSION::MAJOR
    end

    def self.version_string
      return unless enabled?
      ::ActiveRecord::VERSION::STRING
    end

    def self.cast_boolean(val)
      # Emulate the Rails typecast that happens in case the value originated
      # from a web form where the value is typically "0"/"1".
      case major_version
      when 5
        ::ActiveRecord::Type::Boolean.new.cast(val)
      when 4
        ::ActiveRecord::Type::Boolean.new.type_cast_from_user(val)
      when 3
        ::ActiveRecord::ConnectionAdapters::Column.value_to_boolean(val)
      else
        val # Unsupported ActiveRecord version. Just return truthiness of value.
      end
    end
  end
end

# frozen_string_literal: true

# regulate access to instance variables
module Accessors
  def self.included(base)
    base.extend ClassMethods
  end

  # methods for special access to attrs
  module ClassMethods
    def attr_accessor_with_history(*names)
      names.each do |name|
        var_name = "@#{name}".to_sym

        define_method("#{name}_history") do
          if instance_variable_get("@#{name}_h").nil?
            instance_variable_set("@#{name}_h", [])
          else
            instance_variable_get("@#{name}_h")
          end
        end
        define_method(name) { instance_variable_get(var_name) }

        define_method("#{name}=") do |value|
          instance_variable_set(var_name, value)
          send("#{name}_history") << value
        end
      end
    end

    def strong_attr_accessor(attr, attr_class)
      var_name = "@#{attr}".to_sym

      define_method(attr) { instance_variable_get(var_name) }
      define_method("#{attr}=") do |value|
        if value.is_a?(attr_class)
          instance_variable_set(var_name, value)
        else
          raise "Wrong type, #{attr_class} expected, got #{value.class}"
        end
      end
    end
  end
end

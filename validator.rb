# frozen_string_literal: true

# mixin for validating attributes in RW-system
module Validation
  def self.included(base)
    base.extend ClassMethods
    base.include(InstanceMethods)
  end

  module ClassMethods
    def validate(attr, valid_type, *args)
      var_name = "@#{attr}".to_sym
      case valid_type
      when :presence
        define_method("#{attr}_presence_valid") do
          raise 'Nil attribute' if instance_variable_get(var_name).nil?
          raise 'Empty line' if instance_variable_get(var_name).empty?
        end
      when :format
        define_method("#{attr}_format_valid") do
          raise 'Does not fit pattern' if instance_variable_get(var_name) !~ args[0]
        end
      else
        define_method("#{attr}_type_valid") do
          raise 'Wrong argument type' unless instance_variable_get(var_name).is_a?(args[0])
        end
      end
    end
  end

  module InstanceMethods
    def validate!
      validate_regexp = /.+(valid)$/
      methods.each do |method|
        send(method) unless method.to_s !~ validate_regexp
      end
    end

    def valid?
      validate!
      true
    rescue RuntimeError
      false
    end
  end
end

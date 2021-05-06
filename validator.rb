# frozen_string_literal: true

# mixin for validating attributes in RW-system
module Validation
  def self.included(base)
    base.extend ClassMethods
    base.include(InstanceMethods)
  end

  module ClassMethods
    attr_writer :validations

    def validations
      @validations ||= []
    end

    def validate(attr, valid_type, *args)
      validation = [valid_type, attr]
      validation << args[0] unless args.empty?
      validations << validation
    end
  end

  module InstanceMethods
    def valid?
      validate!
      true
    rescue RuntimeError
      false
    end

    def validate!
      self.class.validations.each do |validation|
        var_name = "@#{validation[1]}".to_sym
        case validation[0]
        when :presence
          validate_presence(var_name)
        when :format
          validate_format(var_name, validation[2])
        when :type
          validate_type(var_name, validation[2])
        else
          'unknown validation'
        end
      end
    end

    protected

    def validate_presence(attr)
      raise 'Nil attribute' if attr.nil?
      raise 'Empty line' if instance_variable_get(attr).empty?
    end

    def validate_format(attr, regex)
      raise 'Does not fit pattern' if instance_variable_get(attr) !~ regex
    end

    def validate_type(attr, type)
      raise 'Wrong argument type' unless instance_variable_get(attr).instance_of?(type)
    end
  end
end

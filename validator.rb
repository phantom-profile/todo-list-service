# frozen_string_literal: true

# mixin for validating attributes in RW-system
module Validation
  def self.included(base)
    base.extend(ClassMethods)
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
        var = instance_variable_get(var_name)
        send("validate_#{validation[0]}", var, validation[2])
      end
    end

    protected

    def validate_presence(attr, *_args)
      raise 'Nil attribute' if attr.nil?
      raise 'Empty line' if attr.to_s.empty?
    end

    def validate_format(attr, regex)
      raise 'Does not fit pattern' if attr !~ regex
    end

    def validate_type(attr, type)
      raise 'Wrong argument type' unless attr.is_a?(type)
    end
  end
end

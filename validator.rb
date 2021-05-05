# frozen_string_literal: true

# mixin for validating attributes in RW-system
module Validation
  def self.included(base)
    base.include(InstanceMethods)
  end

  module InstanceMethods
    def validate_presence(attr)
      raise 'Nil attribute' if attr.nil?
      raise 'Empty line' if attr.empty?
    end

    def validate_format(attr, regex)
      raise 'Does not fit pattern' if attr !~ regex
    end

    def validate_type(attr, type)
      raise 'Wrong argument type' unless attr.instance_of?(type)
    end

    def validate!; end

    def valid?
      validate!
      true
    rescue RuntimeError
      false
    end
  end
end

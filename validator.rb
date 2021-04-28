# frozen_string_literal: true

# mixin for validating attributes in RW-system
module Validator
  def valid?
    validate!
    true
  rescue RuntimeError
    false
  end

  protected

  def validate_name!(obj_name, reg_pattern = /.*/)
    raise "#{obj_name} must not be nil" if obj_name.nil?
    raise "#{obj_name} name must not be empty" if obj_name.empty?
    raise "#{obj_name} does not fit pattern" if obj_name !~ reg_pattern
  end

  def validate_type!(types, type)
    raise "#{type} must be in #{types}" unless types.include?(type)
  end

  def validate_size(self_size, needed_size)
    raise "Size must be #{needed_size}, not #{self_size}" if self_size < needed_size
  end

  def validate!; end

  def show_error(error)
    puts error
    puts 'Попробуйте снова:'
  end
end

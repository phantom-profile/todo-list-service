# frozen_string_literal: true

require_relative 'car'

# component of cargo train
class CargoCar < Car
  attr_reader :type

  def initialize
    @type = 'cargo'
    super
    validate!
  end
end

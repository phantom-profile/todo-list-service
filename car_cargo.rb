# frozen_string_literal: true

require_relative 'car'

# component of cargo train
class CargoCar < Car
  attr_reader :type

  def initialize
    super
    @type = 'cargo'
  end
end

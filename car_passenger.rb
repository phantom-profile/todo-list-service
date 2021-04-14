# frozen_string_literal: true

require_relative 'car'

# component of passenger train
class PassengerCar < Car
  attr_reader :type

  def initialize
    super
    @type = 'passenger'
  end
end

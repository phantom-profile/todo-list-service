# frozen_string_literal: true

require_relative 'car'

# component of passenger train
class PassengerCar < Car
  attr_reader :type, :empty_sits, :occupied_sits

  def initialize(sits)
    @empty_sits = sits
    @occupied_sits = 0
    @type = 'passenger'
    super()
  end

  def take_sit
    return if empty_sits.zero?

    self.empty_sits -= 1
    self.occupied_sits += 1
  end

  def to_s
    super + "Empty sits #{empty_sits}, occupied sits #{occupied_sits}"
  end

  protected

  attr_writer :empty_sits, :occupied_sits
end

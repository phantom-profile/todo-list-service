# frozen_string_literal: true

require_relative 'car'

# component of passenger train
class PassengerCar < Car
  attr_reader :type, :empty_places, :occupied_places

  def initialize(places)
    @empty_places = places
    @occupied_places = 0
    @type = 'passenger'
    super()
    validate!
  end

  def take_place
    return if self.empty_places.zero?

    self.empty_places -= 1
    self.occupied_places += 1
  end

  protected

    attr_writer :empty_places, :occupied_places
end

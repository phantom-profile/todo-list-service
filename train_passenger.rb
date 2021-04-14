# frozen_string_literal: true

require_relative 'train'

# train which transports people
class PassengerTrain < Train
  attr_reader :type

  def initialize(train_name)
    super
    @type = 'passenger'
  end

  def add_car(car)
    super if car.type == type
  end
end

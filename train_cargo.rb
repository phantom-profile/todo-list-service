# frozen_string_literal: true

require_relative 'train'

# train which transports cargos
class CargoTrain < Train
  attr_reader :type

  def initialize(train_name)
    super
    @type = 'cargo'
  end

  def add_car(car)
    super if car.type == type
  end
end

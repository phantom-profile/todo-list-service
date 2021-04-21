# frozen_string_literal: true

require_relative 'train'

# train which transports cargos
class CargoTrain < Train
  attr_reader :type

  @instances = 0

  def initialize(train_name, number)
    super
    @type = 'cargo'
  end
end

# frozen_string_literal: true

require_relative 'car'

# component of cargo train
class CargoCar < Car
  attr_reader :type, :volume, :occupied_volume

  def initialize(volume)
    @type = 'cargo'
    @volume = volume
    @occupied_volume = 0
    super()
    validate!
  end

  def load_cargo(volume)
    return if (self.volume - volume).negative?

    self.volume -= volume
    self.occupied_volume += volume
  end

  def to_s
    super + "Empty volume #{volume}, occupied volume #{occupied_volume}"
  end

  protected

  attr_writer :volume, :occupied_volume
end

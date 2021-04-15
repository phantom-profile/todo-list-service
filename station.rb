# frozen_string_literal: true

# Location for trains and also objects included in routs
class Station
  attr_reader :name, :trains

  def initialize(name)
    @name = name
    @trains = []
  end

  def meet_train(train)
    trains << train
  end

  def send_train(train)
    trains.delete(train)
  end

  def trains_count_by(type)
    trains_by(type).size
  end

  def trains_by(type)
    trains.filter { |train| train.type == type }
  end

  def to_s
    "Station - #{name}"
  end

  private

  # Client code mustn't have write-access to class attrs directly
  attr_writer :trains
end

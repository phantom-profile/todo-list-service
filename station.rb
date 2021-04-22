# frozen_string_literal: true

require_relative 'instance_counter'

# Location for trains and also objects included in routs
class Station
  include InstanceCounter
  attr_reader :name, :trains

  def self.all
    @@all ||= []
  end

  def initialize(name)
    @name = name
    @trains = []
    self.class.all << self
    register_instances
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

  @@stations = []
end

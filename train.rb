# frozen_string_literal: true

require_relative 'producer_name_module'
require_relative 'instance_counter'
require_relative 'validator'

# Train with speed, cars, which locates on station and moves on its route
class Train
  include ProducerName
  include InstanceCounter
  include Validator

  attr_reader :train_name, :cars, :number
  attr_accessor :speed

  NUM_PATTERN = /^[\w\d]{3}-?[\w\d]{2}$/i.freeze
  TYPES = %w[cargo passenger].freeze

  def self.find(number)
    filtered = @@trains.filter { |train| train.number == number }
    filtered[0]
  end

  def initialize(train_name, number)
    @train_name = train_name
    @number = number
    @cars = []
    @speed = 0
    validate!
    @@trains << self
    register_instances
  end

  def add_car(car)
    car.change_owner(self)
    cars << car if car.type == type
  end

  def remove_car
    cars.delete_at(-1)
  end

  def take_route(new_route)
    self.route = new_route
    self.current_station_index = 0
    current_station.meet_train(self)
  end

  def current_station
    return if route.nil?

    route.stations[current_station_index]
  end

  def prev_station
    return if route.nil?

    route.stations[current_station_index - 1] unless current_station_index.zero?
  end

  def next_station
    return if route.nil?

    route.stations[current_station_index + 1] unless current_station_index == route.stations.size - 1
  end

  def move_forward
    return if speed.zero?

    return unless next_station

    current_station.send_train(self)
    self.current_station_index += 1
    current_station.meet_train(self)
  end

  def move_back
    return if speed.zero?

    return unless prev_station

    current_station.send_train(self)
    self.current_station_index -= 1
    current_station.meet_train(self)
  end

  def for_car_do(&block)
    cars.each(&block)
  end

  def to_s
    "Train number #{number} of type #{type}. Cars' number - #{cars.size}"
  end

  protected

  @@trains = []

  # all these attrs are needed inside this and child classes but not for client code
  attr_accessor :current_station_index, :route
  attr_writer :cars

  def validate!
    validate_name!(number, NUM_PATTERN)
    validate_name!(train_name)
  end
end

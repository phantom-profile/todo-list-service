# frozen_string_literal: true

# Train with speed, cars, which locates on station and moves on its route
class Train
  attr_reader :train_name, :cars
  attr_accessor :speed

  def initialize(train_name)
    @train_name = train_name
    @cars = []
    @speed = 0
  end

  def add_car(car)
    car.change_owner(self)
    cars << car
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

  def to_s
    "train #{train_name} - type #{type}"
  end

  protected

  # all these attrs are needed inside this and child classes but not for client code
  attr_accessor :current_station_index, :route
  attr_writer :cars
end

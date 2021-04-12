# frozen_string_literal: true

# Train with speed, cars, own type, which locates on station and moves on its route
class Train
  attr_reader :train_name, :type

  def initialize(train_name, type)
    @train_name = train_name
    @type = type
    @cars = []
    @speed = 0
  end

  def raise_speed(add_speed)
    self.speed += add_speed
  end

  def stop
    self.speed = 0
  end

  def add_car; end

  def remove_car; end

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

  protected

  # all these attrs are needed inside this and child classes but not for client code
  attr_accessor :speed, :current_station_index, :route, :cars
end

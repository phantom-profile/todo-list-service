# frozen_string_literal: true

# Location for trains and also objects included in routs
class Station
  attr_accessor :trains
  attr_reader :name

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
    trains_counter = 0
    trains.each do |train|
      trains_counter += 1 if train.type == type
    end
  end

  def trains_by(type)
    typed_trains = []
    trains.each do |train|
      typed_trains << train if train.type == type
    end
    typed_trains
  end
end

# Route which contains many stations and also is way for trains
class Route
  attr_accessor :stations

  def initialize(start_station, end_station)
    @stations = [start_station, end_station]
  end

  def add_mid_station(station)
    stations.insert(-2, station)
  end

  def remove_mid_station(station)
    stations.delete(station)
  end
end

# Train with speed, cars, own type, which locates on station and moves on its rout
class Train
  attr_accessor :cars_number, :speed, :current_station_index, :route
  attr_reader :train_name, :type

  def initialize(train_name, type, cars_number = 10)
    @train_name = train_name
    @type = type
    @cars_number = cars_number
    @speed = 0
  end

  def raise_speed(add_speed)
    self.speed += add_speed
  end

  def stop
    self.speed = 0
  end

  def add_car
    self.cars_number += 1 if self.speed.zero?
  end

  def remove_car
    self.cars_number -= 1 if self.speed.zero?
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

    if next_station
      current_station.send_train(self)
      self.current_station_index += 1
      current_station.meet_train(self)
    else
      'Last station, this train terminates here'
    end
  end

  def move_back
    return if speed.zero?

    if prev_station
      current_station.send_train(self)
      self.current_station_index -= 1
      current_station.meet_train(self)
    else
      'Last station, this train terminates here'
    end
  end
end

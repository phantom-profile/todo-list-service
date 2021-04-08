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

  def show_trains
    trains.each do |train|
      puts train.train_name
    end
  end

  def cargos_count
    cargos = 0
    trains.each do |train|
      cargos += 1 if train.type == 'cargo'
    end
    cargos
  end

  def passengers_count
    passengers = 0
    trains.each do |train|
      passengers += 1 if train.type == 'passenger'
    end
    passengers
  end

  def show_cargos
    trains.each do |train|
      puts train if train.type == 'cargo'
    end
  end

  def show_passengers
    trains.each do |train|
      puts train if train.type == 'passenger'
    end
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
    if self.speed.zero?
      self.cars_number += 1
    else
      'Need to stop the train'
    end
  end

  def remove_car
    if self.speed.zero?
      self.cars_number -= 1
    else
      'Need to stop the train'
    end
  end

  def take_route(new_route)
    self.route = new_route
    self.current_station_index = 0
    route.stations[current_station_index].meet_train(self)
  end

  def show_current_station
    return 'no route - no stations' if route.nil?

    route.stations[current_station_index]
  end

  def show_prev_station
    return 'no route - no stations' if route.nil?

    route.stations[current_station_index - 1] unless current_station_index.zero?
  end

  def show_next_station
    return 'no route - no stations' if route.nil?

    route.stations[current_station_index + 1] unless current_station_index == route.stations.size - 1
  end

  def move_forward
    return 'no route - no stations' if route.nil?

    return 'raise speed for movement' if speed.zero?

    if current_station_index != route.stations.size - 1
      route.stations[current_station_index].send_train(self)
      self.current_station_index += 1
      route.stations[current_station_index].meet_train(self)
    else
      'Last station, this train terminates here'
    end
  end

  def move_back
    return 'no route - no stations' if route.nil?

    return 'raise speed for movement' if speed.zero?

    if !current_station_index.zero?
      route.stations[current_station_index].send_train(self)
      self.current_station_index -= 1
      route.stations[current_station_index].meet_train(self)
    else
      'Last station, this train terminates here'
    end
  end
end

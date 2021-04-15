# frozen_string_literal: true

require_relative 'route'
require_relative 'station'

require_relative 'car_cargo'
require_relative 'car_passenger'

require_relative 'train_cargo'
require_relative 'train_passenger'

# interface for train railways system control
class Interface
  def initialize
    @trains = []
    @stations = []
    @routes = []
    puts start
  end

  def run!
    choice = 0

    while choice != 13

      choice = gets.chomp.to_i
      case choice
      when 1
        make_train

      when 2
        set_train_speed

      when 3
        add_train_car

      when 4
        remove_train_car

      when 5
        make_station

      when 6
        make_route

      when 7
        add_or_delete_station

      when 8
        set_route_for_train

      when 9
        move_train_forward

      when 10
        move_train_back

      when 11
        display_route_stations

      when 12
        display_station_trains

      when 13
        end_session

      else
        puts 'Некорректный ввод'
      end
    end
  end

  private

  attr_accessor :stations, :trains, :routes

  def start
    <<~MENU
      Выберите действие:
         1 - создать поезд
         2 - задать скорость поезда
         3 - присоединить вагон к поезду (при наличии поезда)
         4 - отцепить вагон от поезда (при наличии поезда)
         5 - создать станцию
         6 - создать маршрут (при наличии двух станций)
         7 - добавить или удалить станцию маршрута
         8 - добавить поезд в маршрут
         9 - переместить поезд вперед
         10 - переместить поезд назад
         11 - посмотреть список станций на маршруте
         12 - посмотреть список поездов на станции
         13 - выход
    MENU
  end

  def make_train
    puts 'название поезда'
    name = gets.chomp
    puts 'тип поезда "груз" или "пасс"'
    type = gets.chomp
    trains << CargoTrain.new(name) if type == 'груз'
    trains << PassengerTrain.new(name) if type == 'пасс'
  end

  def set_train_speed
    train = choose_from(trains)
    train.speed = gets.chomp.to_i
  end

  def add_train_car
    train = choose_from(trains)
    train.add_car(PassengerCar.new)
    train.add_car(CargoCar.new)
  end

  def remove_train_car
    train = choose_from(trains)
    train.remove_car
  end

  def make_station
    puts 'Название станции'
    stations << Station.new(gets.chomp)
  end

  def make_route
    puts 'Нужно наличие минимум двух станций'
    return if stations.size < 2

    start_station = choose_from(stations)
    end_station = choose_from(stations)
    routes << Route.new(start_station, end_station)
  end

  def add_or_delete_station
    route = choose_from(routes)

    puts '1 - добавить станцию, 2 - удалить станцию'
    choice = gets.chomp.to_i
    case choice
    when 1
      station = choose_from(stations)
      route.add_mid_station(station)
    when 2
      station = choose_from(route.stations)
      route.remove_mid_station(station)
    else
      'Некорректный ввод'
    end
  end

  def set_route_for_train
    train = choose_from(trains)
    route = choose_from(routes)
    train.take_route(route)
  end

  def move_train_forward
    train = choose_from(trains)
    train.move_forward
  end

  def move_train_back
    train = choose_from(trains)
    train.move_back
  end

  def display_route_stations
    route = choose_from(routes)
    puts route.stations
  end

  def display_station_trains
    station = choose_from(stations)
    puts station.trains
  end

  def end_session
    puts 'Goodbye, User!'
  end

  def choose_from(obj_list)
    puts 'Выберите вариант'
    i = 0
    obj_list.each do |obj|
      puts "#{i} - #{obj}"
      i += 1
    end
    obj_list[gets.chomp.to_i]
  end
end

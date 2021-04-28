# frozen_string_literal: true

require_relative 'route'
require_relative 'station'

require_relative 'car_cargo'
require_relative 'car_passenger'

require_relative 'train_cargo'
require_relative 'train_passenger'

require_relative 'validator'

# interface for train railways system control
class Interface
  include Validator

  def initialize
    @trains = []
    @stations = []
    @routes = []
    puts start
  end

  def run!
    choice = 0

    while choice != 16

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
        display_train_cars
      when 14
        place_passenger
      when 15
        load_cargo
      when 16
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
         13 - посмотреть список вагонов в поезде
         14 - посадить в вагон человека
         15 - погрузить товары в вагон
         16 - выход
    MENU
  end

  def make_train
    puts 'название поезда'
    name = gets.chomp
    puts 'тип поезда "груз" или "пасс"'
    type = gets.chomp
    raise 'Cинтаксическая ошибка, варианты: "груз", "пасс"' if type != 'груз' && type != 'пасс'

    puts 'Номер поезда в формате a1a-1a'
    number = gets.chomp
    trains << CargoTrain.new(name, number) if type == 'груз'
    trains << PassengerTrain.new(name, number) if type == 'пасс'
    puts 'Поезд успешно создан!'
  rescue RuntimeError => e
    show_error(e)
    retry
  end

  def set_train_speed
    train = choose_from(trains)
    train.speed = gets.chomp.to_i
  end

  def add_train_car
    train = choose_from(trains)
    if train.type == 'passenger'
      puts 'Количество пассажирских мест:'
      train.add_car(PassengerCar.new(gets.chomp.to_i))
    else
      puts 'Грузовая вместимость:'
      train.add_car(CargoCar.new(gets.chomp.to_i))
    end
  rescue RuntimeError => e
    show_error(e)
    retry
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
    station.for_train_do { |train| puts train }
  end

  def display_train_cars
    train = choose_from(trains)
    train.for_car_do { |car| puts car }
  end

  def place_passenger
    chosen_train = choose_from(trains.filter { |train| train.speed.zero? && train.type == 'passenger' })
    car = choose_from(chosen_train.cars)
    car.take_sit
    puts 'Человек занял место!'
  end

  def load_cargo
    chosen_train = choose_from(trains.filter { |train| train.speed.zero? && train.type == 'cargo' })
    car = choose_from(chosen_train.cars)
    puts 'Какое количество груза поместить?'
    car.load_cargo(gets.chomp.to_i)
    puts 'Товар успешно загружен!'
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

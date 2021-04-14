# frozen_string_literal: true

require_relative 'route'
require_relative 'station'

require_relative 'car_cargo'
require_relative 'car_passenger'

require_relative 'train_cargo'
require_relative 'train_passenger'

puts 'Выберите действие:'
puts '1 - создать поезд'
puts '2 - задать скорость поезда'
puts '3 - присоединить вагон к поезду (при наличии поезда)'
puts '4 - отцепить вагон от поезда (при наличии поезда)'
puts '5 - создать станцию'
puts '6 - создать маршрут (при наличии двух станций)'
puts '7 - добавить или удалить станцию маршрута'
puts '8 - добавить поезд в маршрут'
puts '9 - переместить поезд вперед'
puts '10 - переместить поезд назад'
puts '11 - посмотреть список станций на маршруте'
puts '12 - посмотреть список поездов на станции'

trains = []
stations = []
routes = []

def choose_from(obj_list)
  puts 'Выберите вариант'
  i = 0
  obj_list.each do |obj|
    puts "#{i} - #{obj}"
    i += 1
  end
  obj_list[gets.chomp.to_i]
end

while TRUE

  choice = gets.chomp.to_i
  case choice
  when 1
    puts 'название поезда'
    name = gets.chomp
    puts 'тип поезда "груз" или "пасс"'
    type = gets.chomp
    trains << CargoTrain.new(name) if type == 'груз'
    trains << PassengerTrain.new(name) if type == 'пасс'

  when 2
    train = choose_from(trains)
    train.speed = gets.chomp.to_i

  when 3
    train = choose_from(trains)
    train.add_car(PassengerCar.new)
    train.add_car(CargoCar.new)

  when 4
    train = choose_from(trains)
    train.remove_car
  when 5
    puts 'Название станции'
    stations << Station.new(gets.chomp)

  when 6
    puts 'Нужно наличие минимум двух станций'
    return if stations.size < 2

    start_station = choose_from(stations)
    end_station = choose_from(stations)
    routes << Route.new(start_station, end_station)

  when 7
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

  when 8
    train = choose_from(trains)
    route = choose_from(routes)
    train.take_route(route)

  when 9
    train = choose_from(trains)
    train.move_forward

  when 10
    train = choose_from(trains)
    train.move_back

  when 11
    route = choose_from(routes)
    puts route.stations

  when 12
    station = choose_from(stations)
    puts station.trains

  when 13
    break
  else
    puts 'Некорректный ввод'
  end
end

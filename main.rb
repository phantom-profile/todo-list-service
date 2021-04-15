# frozen_string_literal: true

require_relative 'interface'

interface = Interface.new

choice = 0

while choice != 13

  choice = gets.chomp.to_i
  case choice
  when 1
    interface.make_train

  when 2
    interface.set_train_speed

  when 3
    interface.add_train_car

  when 4
    interface.remove_train_car

  when 5
    interface.make_station

  when 6
    interface.make_route

  when 7
    interface.add_or_delete_station

  when 8
    interface.set_route_for_train

  when 9
    interface.move_train_forward

  when 10
    interface.move_train_back

  when 11
    interface.display_route_stations

  when 12
    interface.display_station_trains

  when 13
    interface.end_session

  else
    puts 'Некорректный ввод'
  end
end

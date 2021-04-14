# frozen_string_literal: true

require_relative 'route'
require_relative 'station'

require_relative 'car_cargo'
require_relative 'car_passenger'

require_relative 'train_cargo'
require_relative 'train_passenger'

@s1 = Station.new('Moscow')
@s2 = Station.new('Volgograd')
@s3 = Station.new('St. Petersburg')

@r1 = Route.new(@s1, @s2)
@r2 = Route.new(@s1, @s3)
@r2.add_mid_station(@s2)

@t1 = PassengerTrain.new('Msk-Vlg')
@t2 = PassengerTrain.new('Msk-Vlg-Spb')

@t1.take_route(@r1)
@t2.take_route(@r2)

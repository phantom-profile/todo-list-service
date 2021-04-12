# frozen_string_literal: true

require_relative 'route'
require_relative 'station'
require_relative 'train'

@s1 = Station.new('Moscow')
@s2 = Station.new('Volgograd')
@s3 = Station.new('St. Petersburg')

@r1 = Route.new(@s1, @s2)
@r2 = Route.new(@s1, @s3)
@r2.add_mid_station(@s2)

@t1 = Train.new('Msk-Vlg', 'passenger')
@t2 = Train.new('Msk-Vlg-Spb', 'cargo')

@t1.route = @r1
@t2.route = @r2

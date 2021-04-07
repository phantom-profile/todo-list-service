# frozen_string_literal: true

# Location for trains and also included in routs
class Station
	attr_accessor :trains

	def initialize(name)
		@name = name
		@trains = []
	end
end

# Route which contains many stations and also is way for trains
class Route
	attr_accessor :start_station, :between_stations, :end_station

	def initialize(start_station, end_station)
		@start_station = start_station
		@end_station = end_station
		@between_stations = []
	end
end

# Train with speed, cars, own type, which locates on station and moves on its rout
class Train
	attr_accessor :cars_number, :speed, :location
	attr_writer :route
	attr_reader :train_name, :type

	def initialize(train_name, type, cars_number)
		@train_name = train_name
		@type = type
		@cars_number = cars_number
		@speed = 0
		@route = nil
		@location = []
	end
end

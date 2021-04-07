# frozen_string_literal: true

# Location for trains and also objects included in routs
class Station
	attr_accessor :trains, :cargos, :passengers
	attr_reader :name

	def initialize(name)
		@name = name
		@cargos = 0
		@passengers = 0
		@trains = []
	end

	def meet_train(train)
		trains << train
		case train.type
		when 'cargo'
			self.cargos += 1
		when 'passenger'
			self.passengers += 1
		else
			'Unknown type train'
		end
	end

	def send_train(train)
		trains.delete(train)
	end

	def show_trains
		trains.each do |train|
			puts train.train_name
		end
	end

	def show_num_in_types
		puts "Cargo trains - #{cargos}, Passenger trains - #{passengers}"
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

	def add_mid_station(station)
		between_stations << station
	end

	def remove_mid_station(station)
		between_stations.delete(station)
	end

	def show_stations
		puts start_station.name
		between_stations.each do |station|
			puts station.name
		end
		puts end_station.name
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

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
		case train.type
		when 'cargo'
			self.cargos -= 1
		when 'passenger'
			self.passengers -= 1
		else
			'Unknown type train'
		end
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

	def show_stations
		stations.each do |station|
			puts station.name
		end
	end
end

# Train with speed, cars, own type, which locates on station and moves on its rout
class Train
	attr_accessor :cars_number, :speed, :location, :route
	attr_reader :train_name, :type

	def initialize(train_name, type, cars_number = 10)
		@train_name = train_name
		@type = type
		@cars_number = cars_number
		@speed = 0
		@route = nil
		@location = 0
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
		self.location = 0
		route.stations[location].meet_train(self)
	end

	def show_nearest_stations
		return 'no route - no stations' if route.nil?

		stations = []
		train_stops = route.stations
		case location
		when 0
			stations << train_stops[location] << train_stops[location + 1]
		when route.stations.size - 1
			stations << train_stops[location - 1] << train_stops[location]
		else
			stations << train_stops[location - 1] << train_stops[location] << train_stops[location + 1]
		end
		stations.each do |station|
			puts station.name
		end
	end

	def move_forward
		return 'no route - no stations' if route.nil?

		return 'raise speed for movement' if speed.zero?

		if location != route.stations.size - 1
			route.stations[location].send_train(self)
			self.location += 1
			route.stations[location].meet_train(self)
		else
			'Last station, this train terminates here'
		end
	end

	def move_back
		return 'no route - no stations' if route.nil?

		return 'raise speed for movement' if speed.zero?

		if !location.zero?
			route.stations[location].send_train(self)
			self.location -= 1
			route.stations[location].meet_train(self)
		else
			'Last station, this train terminates here'
		end
	end
end

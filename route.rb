# frozen_string_literal: true

# Route which contains many stations and also is way for trains
class Route
  attr_reader :stations

  def initialize(start_station, end_station)
    @stations = [start_station, end_station]
  end

  def add_mid_station(station)
    stations.insert(-2, station)
  end

  def remove_mid_station(station)
    stations.delete(station)
  end

  def to_s
    "route from #{stations[0]} to #{stations[-1]}"
  end

  private

  # Client code mustn't have write-access to class attrs directly
  attr_writer :stations
end

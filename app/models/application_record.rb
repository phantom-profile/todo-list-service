# frozen_string_literal: true

class ApplicationRecord
  attr_accessor :id

  def self.create(**params)
    new(**params)
  end

  def initialize(**params)
    params.each_pair do |name, value|
      instance_variable_set("@#{name}", value)
    end
  end
end

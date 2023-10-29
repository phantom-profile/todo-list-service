# frozen_string_literal: true

class Product < ApplicationRecord
  attr_accessor :name

  def self.find(id)
    new(id: id, name: SecureRandom.hex)
  end
end

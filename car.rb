# frozen_string_literal: true

require_relative 'producer_name_module'

# component of train
class Car
  include ProducerName

  @@number = 1

  def initialize
    set_number
  end

  TYPES = %w[cargo passenger].freeze

  def change_owner(train)
    return self.owner = train if owner.nil?

    owner.remove_car(self)
    self.owner = train
  end

  def to_s
    "Car number #{number} of #{type} type. "
  end

  protected

  attr_accessor :owner, :number

  def set_number
    self.number = @@number
    @@number += 1
  end
end

# frozen_string_literal: true

require_relative 'producer_name_module'

# component of train
class Car
  include ProducerName

  def change_owner(train)
    return self.owner = train if owner.nil?

    owner.remove_car(self)
    self.owner = train
  end

  protected

  attr_accessor :owner
end

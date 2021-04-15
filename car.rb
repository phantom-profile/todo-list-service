# frozen_string_literal: true

# component of train
class Car
  def change_owner(train)
    return self.owner = train if owner.nil?

    owner.remove_car(self)
    self.owner = train
  end

  protected

  attr_accessor :owner
end

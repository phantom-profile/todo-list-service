# frozen_string_literal: true

require_relative 'train'

# train which transports people
class PassengerTrain < Train
  attr_reader :type

  def initialize(train_name, number)
    super
    @type = 'passenger'
  end
end

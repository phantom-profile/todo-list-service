# frozen_string_literal: true

class User < ApplicationRecord
  attr_accessor :email, :cloud_payments_uid

  def initialize(email:, id:)
    super(email: email, id: id)
    @cloud_payments_uid = SecureRandom.hex
  end
end

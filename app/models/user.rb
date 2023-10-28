# frozen_string_literal: true

class User
  attr_accessor :email, :id, :cloud_payments_uid

  def initialize(email:, id:)
    @email = email
    @id = id
    @cloud_payments_uid = SecureRandom.hex
  end
end

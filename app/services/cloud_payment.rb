# frozen_string_literal: true

class CloudPayment
  FAIL = 'failed'
  SUCCESS = 'success'

  def self.process(user_uid:, amount_cents:, currency:)
    puts "process payment with args: #{user_uid}, #{amount_cents}, #{currency}"
    { status: [SUCCESS, SUCCESS, FAIL].sample}
  end
end

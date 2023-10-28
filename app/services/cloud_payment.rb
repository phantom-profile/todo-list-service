# frozen_string_literal: true

class CloudPayment
  def process(user_uid:, amount_cents:, currency:)
    puts "process payment with args: #{user_uid}, #{amount_cents}, #{currency}"
    { status: %w[completed completed failed].sample}
  end
end

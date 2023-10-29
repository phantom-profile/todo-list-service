# frozen_string_literal: true

class SdekClient
  FAIL = 'failed'
  SUCCESS = 'success'

  def self.setup_delivery(address:, person:, weight:)
    # sdek API request
    response = [address, person, weight].any?(&:blank?) ? FAIL : SUCCESS
    { result: response }
  end
end

# frozen_string_literal: true

class SdekClient
  def self.setup_delivery(address:, person:, weight:)
    # sdek API request
    response = [address, person, weight].any?(&:blank?) ? 'failed' : 'success'
    { result: response }
  end
end

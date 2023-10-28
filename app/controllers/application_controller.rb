# frozen_string_literal: true

class ApplicationController < ActionController::API
  def current_user
    @current_user ||= User.new(email: 'phantom@client.com', id: 1)
  end
end

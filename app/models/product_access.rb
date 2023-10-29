# frozen_string_literal: true

class ProductAccess < ApplicationRecord
  attr_reader :user, :product
end

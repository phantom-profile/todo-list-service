# frozen_string_literal: true

class PaymentsController < ApplicationController
  def create
    product = Product.find(params[:product_id])
    payment_result = CloudPayment.process(
      user_uid: current_user.cloud_payments_uid,
      amount_cents: params[:amount] * 100,
      currency: 'RUB'
    )

    if payment_result[:status] == 'completed'
      product_access = ProductAccess.create(user: current_user, product: product)
      OrderMailer.product_access_email(product_access).deliver_later
      render json: { product_access: product_access.as_json }, status: 201
    else
      render json: { product_access: nil, error: 'something went wrong' }, status: 400
    end
  end
end

# frozen_string_literal: true

class PaymentsController < ApplicationController
  def create
    result = Payments::Operations::Create.call(params: creation_job_params, current_user: current_user)

    if result.success?
      render json: { product_access: result[:product_access].as_json }, status: 201
    else
      render json: { product_access: nil, error: 'something went wrong' }, status: 400
    end
  end

  private

  def creation_job_params
    params.permit(:amount, :product_id)
  end
end

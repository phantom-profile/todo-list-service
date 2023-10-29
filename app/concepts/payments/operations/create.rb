module Payments::Operations
  class Create < Trailblazer::Operation
    step :params_validating
    step :find_product
    step :process_payment
    fail :add_payment_errors
    step :give_access_to_product
    step :notify_about_purchase
    step :request_delivery
    fail :notify_about_delivery_fail
    step :notify_about_delivery_success

    def params_validating(_ctx, params:, errors:, **)
      %w[product_id amount address person weight].each do |key|
        errors[key] = "#{key} must be filled" if params[key].blank?
      end
      errors.empty?
    end

    def find_product(ctx, params:, **)
      ctx[:product] = Product.find(params[:product_id])
    end

    def process_payment(ctx, params:, current_user:, **)
      ctx[:payment_result] = CloudPayment.process(
        user_uid: current_user.cloud_payments_uid,
        amount_cents: params[:amount] * 100,
        currency: 'RUB'
      )
      ctx[:payment_result][:status] == CloudPayment::SUCCESS
    end

    def add_payment_errors(ctx, errors:, **)
      errors[:product] = 'product does not exist' if ctx[:product].nil?
      payment = ctx[:payment_result]
      errors[:payment] = 'payment was not performed' if payment.nil? || payment[:status] != CloudPayment::SUCCESS
    end

    def give_access_to_product(ctx, current_user:, product:, **)
      ctx[:product_access] = ProductAccess.create(user: current_user, product: product)
      ctx[:product_access].persisted?
    end

    def notify_about_purchase(_ctx, product_access:, **)
      OrderMailer.product_access_email(product_access).deliver_now
    end

    def request_delivery(ctx, params:, **)
      ctx[:delivery_result] = SdekClient.setup_delivery(
        address: params[:address],
        person: params[:person],
        weight: params[:weight]
      )

      ctx[:delivery_result][:result] == SdekClient::SUCCESS
    end

    def notify_about_delivery_success(_ctx, params:, current_user:, **)
      OrderMailer.delivery_approved_email(current_user.email, params[:address])
    end

    def notify_about_delivery_fail(_ctx, params:, current_user:, **)
      OrderMailer.delivery_failed_email(current_user.email, params[:address])
    end
  end
end

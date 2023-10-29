module Payments::Operations
  class Create < Trailblazer::Operation
    step :find_product
    step :process_payment
    step :give_access_to_product
    step :notify_about_purchase

    def find_product(ctx, params:, **)
      ctx[:product] = Product.find(params[:product_id])
    end

    def process_payment(ctx, params:, current_user:, **)
      ctx[:payment_result] = CloudPayment.process(
        user_uid: current_user.cloud_payments_uid,
        amount_cents: params[:amount] * 100,
        currency: 'RUB'
      )
      ctx[:payment_result][:status] == 'completed'
    end

    def give_access_to_product(ctx, current_user:, product:, **)
      ctx[:product_access] = ProductAccess.create(user: current_user, product: product)
      ctx[:product_access].persisted?
    end

    def notify_about_purchase(_ctx, product_access:, **)
      OrderMailer.product_access_email(product_access).deliver_now
    end
  end
end

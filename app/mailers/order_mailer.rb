# frozen_string_literal: true

class OrderMailer < ActionMailer::Base
  default from: 'phantom@company.com'

  def product_access_email(product_access)
    mail to: product_access.user.email, title: 'Successfully purchased'
  end

  def delivery_approved_email(email, address)
    mail to: email, title: "Delivery to #{address} approved"
  end

  def delivery_failed_email(email, address)
    mail to: email, title: "Delivery to #{address} declined"
  end
end

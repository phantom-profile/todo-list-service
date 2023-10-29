# frozen_string_literal: true

class OrderMailer < ActionMailer::Base
  default from: 'phantom@company.com'

  def product_access_email(product_access)
    mail to: product_access.user.email, title: 'Successfully purchased' do |format|
      format.text { render plain: 'Successfully purchased' }
    end
  end

  def delivery_approved_email(email, address)
    mail to: email, title: "Delivery to #{address} approved" do |format|
      format.text { render plain: "Delivery to #{address} approved" }
    end
  end

  def delivery_failed_email(email, address)
    mail to: email, title: "Delivery to #{address} declined" do |format|
      format.text { render plain: "Delivery to #{address} declined" }
    end
  end
end

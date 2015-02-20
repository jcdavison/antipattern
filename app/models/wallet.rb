class Wallet < ActiveRecord::Base
  belongs_to :user

  def set_stripe_customer_id
    begin
      customer = Stripe::Customer.create(source: self.stripe_token, description: self.user.name)
      self.stripe_customer_id = customer.id
      self.save
    rescue => e
      p e
    end
  end

  def has_customer_id?
    ! stripe_customer_id.nil?
  end
end

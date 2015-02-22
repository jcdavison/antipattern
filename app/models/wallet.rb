class Wallet < ActiveRecord::Base
  belongs_to :user

  def has_stripe_account?
    ! stripe_access_token.nil?
  end

  def has_credit_card?
    ! stripe_cc_id.nil?
  end

  def validate detail
    if detail == "stripeAccount"
      has_stripe_account?
    elsif detail == 'creditCard'
      has_credit_card?
    end
  end

  def set_stripe_cc_id
    response = Stripe::Customer.create(source: self.stripe_cc_token, description: self.user.email)
    self.stripe_cc_id = response[:id]
    self.save
  end
end

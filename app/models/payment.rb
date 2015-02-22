class Payment < ActiveRecord::Base
  belongs_to :offer
  FUND_A_CODER_DESC = "Fund A Coder"
  MARKET_TRANSACTION_DESC = "Market Transaction"

  def self.fund_a_coder args
    payment_detail = {offer_id: args[:offer].id, from_id: args[:offer].review_request.user.id, to_id: args[:offer].user_id}
    payment = Payment.new(payment_detail)
    payment.set_fund_a_coder_value
    payment.pay!
  end

  def pay!
    binding.pry
  end

  def from_token
    User.find_by(id: from_id).wallet.stripe_access_token
  end

  def to_token
    User.find_by(id: to_id).wallet.stripe_access_token
  end

  def self.process args
    self.fund_a_coder args
  end

  def set_fund_a_coder_value
    return if offer.fund_a_coder.nil?
    args = {proportion: offer.fund_a_coder, payment_value: offer.gross_payment_value}
    self.value = calculate_payment args 
    self.description = FUND_A_CODER_DESC
  end

  def calculate_payment args
    ((args[:proportion] || 100).to_f / 100) * args[:payment_value]
  end
end

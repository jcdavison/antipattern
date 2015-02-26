class Payment < ActiveRecord::Base
  belongs_to :offer
  FUND_A_CODER_DESC = "AntiPattern.io Fund A Coder"
  FUND_A_CODER_UID = ENV['STRIPE_FUNDACODER_UID']
  ANTIPATTERN_UID = ENV['STRIPE_FUNDACODER_UID']
  MARKET_TRANSACTION_DESC = "Market Transaction"
  TRANSACTION_FEE = 0.03

  def self.fund_a_coder args
    payment_detail = {offer_id: args[:offer].id, from_user_id: args[:offer].review_request.user.id, to_user_id: args[:offer].user_id}
    payment = Payment.new(payment_detail)
    payment.pay! args
  end

  def pay! args
    generate_fund_a_coder_pmt args
    generate_regular_pmt args
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

  def generate_fund_a_coder_pmt args
    return if args[:offer].fund_a_coder.nil?
    fund_a_coder_wallet = specific_wallet(FUND_A_CODER_UID)
    payment_token = get_payment_token(args[:offer].user.wallet, fund_a_coder_wallet) 
    payment_opts = { amount: net_contribution_value(args), 
      token: payment_token, 
      application_fee: contribution_service_fee(args), 
      description: FUND_A_CODER_DESC,
      identifying_token: fund_a_coder_wallet.stripe_access_token }
    stripe_charge payment_opts
  end

  def generate_regular_pmt args
    pay_to_wallet = args[:offer].review_request.user.wallet
    payment_token = get_payment_token(args[:offer].user.wallet, pay_to_wallet) 
    payment_opts = { amount: net_payment_value(args), 
      token: payment_token, 
      application_fee: payment_service_fee(args), 
      description: FUND_A_CODER_DESC,
      identifying_token: pay_to_wallet.stripe_access_token }
    stripe_charge payment_opts
  end

  def get_payment_token from_wallet, to_wallet
    Stripe::Token.create({customer: from_wallet.stripe_customer_id, card: from_wallet.stripe_card_id}, to_wallet.stripe_access_token).id 
  end

  def conduct_stripe_payment value, payment_token, to_wallet 
    Stripe::Charge.create(value: value)
  end

  def stripe_charge args
    charge = Stripe::Charge.create({
      amount: args[:amount],
      currency: 'usd',
      source: args[:token],
      description: args[:description],
      }, args[:identifying_token])
  end

  def gross_payment_value args
    args[:offer].value - gross_contribution_value(args)
  end

  def net_payment_value args
    (gross_payment_value(args) - payment_service_fee(args)).to_i
  end

  def payment_service_fee args
    gross_payment_value(args) * TRANSACTION_FEE
  end

  def net_contribution_value args
    (gross_contribution_value(args) - contribution_service_fee(args)).to_i
  end

  def gross_contribution_value args
    args[:offer].value * (args[:offer].fund_a_coder / 100.to_f)
  end

  def contribution_service_fee args
     (gross_contribution_value(args) * TRANSACTION_FEE).to_i
  end

  def specific_wallet stripe_uid
    Wallet.find_by(stripe_uid: stripe_uid )
  end
end

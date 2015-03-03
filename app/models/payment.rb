class Payment < ActiveRecord::Base
  belongs_to :offer

  FUND_A_CODER_DESC = "AntiPattern.io Fund A Coder Payment"
  MARKET_TRANSACTION_DESC = "AntiPattern.io Market Payment"
  SERVICE_FEE_DESC = "AntiPattern.io Service Fee"
  FUND_A_CODER_UID = ENV['STRIPE_FUNDACODER_UID']
  ANTIPATTERN_UID = ENV['STRIPE_ANTIPATTERN_UID']
  TRANSACTION_FEE = 0.05

  def self.process args
    payment_detail = { offer_id: args[:offer].id, 
      from_user_id: args[:offer].code_review.user.id, 
      to_user_id: args[:offer].user_id }
    payment = Payment.new(payment_detail)
    payment.pay! args
  end

  def pay! args
    fund_a_coder_pmt args
    regular_transaction_pmt args
    service_fee_pmt args
  end

  def fund_a_coder_pmt args
    return unless args[:offer].fund_a_coder && args[:offer].fund_a_coder > 0
    amount = net_contribution_value args
    pay_to_wallet = specific_wallet FUND_A_CODER_UID
    charge_from_wallet = args[:offer].code_review.user.wallet
    description = FUND_A_CODER_DESC 
    payment_args = { amount: amount,
      pay_to_wallet: pay_to_wallet,
      charge_from_wallet: charge_from_wallet,
      description: description }
    generate_payment payment_args
  end

  def regular_transaction_pmt args
    amount = net_regular_payment_value args
    pay_to_wallet = args[:offer].user.wallet
    charge_from_wallet = args[:offer].code_review.user.wallet
    description = MARKET_TRANSACTION_DESC 
    payment_args = { amount: amount,
      pay_to_wallet: pay_to_wallet,
      charge_from_wallet: charge_from_wallet,
      description: description }
    generate_payment payment_args
  end

  def service_fee_pmt args
    amount = net_service_fee args
    pay_to_wallet = specific_wallet ANTIPATTERN_UID
    charge_from_wallet = args[:offer].code_review.user.wallet
    description = SERVICE_FEE_DESC 
    payment_args = { amount: amount,
      pay_to_wallet: pay_to_wallet,
      charge_from_wallet: charge_from_wallet,
      description: description }
    generate_payment payment_args
  end

  def generate_payment args
    pay_to_wallet = args[:pay_to_wallet]
    charge_from_wallet = args[:charge_from_wallet]
    payment_token = get_token charge_from_wallet, pay_to_wallet
    pmt_opts = { amount: args[:amount],
      payment_token: payment_token,
      description: args[:description],
      pay_to_token: pay_to_wallet.stripe_access_token }
    stripe_charge pmt_opts
  end

  def stripe_charge args
    amount = args[:amount] < 50 ? 50 : args[:amount]
    payment_opts = { amount: amount,
      currency: 'usd',
      source: args[:payment_token],
      description: args[:description] }
    Stripe::Charge.create(payment_opts, args[:pay_to_token])
  end

  def get_token from_wallet, to_wallet
    from_opts = {customer: from_wallet.stripe_customer_id, card: from_wallet.stripe_card_id}
    Stripe::Token.create(from_opts, to_wallet.stripe_access_token).id 
  end

  def from_token
    User.find_by(id: from_id).wallet.stripe_access_token
  end

  def to_token
    User.find_by(id: to_id).wallet.stripe_access_token
  end

  def conduct_stripe_payment value, payment_token, to_wallet 
    Stripe::Charge.create(value: value)
  end

  def gross_regular_payment_value args
    args[:offer].value - gross_contribution_value(args)
  end

  def net_regular_payment_value args
    (gross_regular_payment_value(args) - payment_service_fee(args)).to_i
  end

  def payment_service_fee args
    (gross_regular_payment_value(args) * TRANSACTION_FEE).to_i
  end

  def net_service_fee args
    payment_service_fee(args) + contribution_service_fee(args)
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

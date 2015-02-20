class Api::TokensController < ApplicationController
  before_filter :authenticate_user!

  def show
    if current_user.wallet.has_customer_id?
      head :ok
    else
      head :forbidden
    end
  end

  def create
    wallet = current_user.wallet 
    if wallet
      wallet.update_attributes stripe_token: params[:stripe_token]
      wallet.set_stripe_customer_id
      head :ok
    else
      wallet = Wallet.new stripe_token: params[:stripe_token], user_id: current_user.id
      if wallet.save && wallet.set_stripe_customer_id
        head :ok
      else
        head :forbidden
      end
    end
  end

end

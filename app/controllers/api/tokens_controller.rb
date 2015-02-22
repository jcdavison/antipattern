class Api::TokensController < ApplicationController
  before_filter :authenticate_user!

  def show
    if current_user.wallet.ready_to_pay?
      head :ok
    else
      head :forbidden
    end
  end
end

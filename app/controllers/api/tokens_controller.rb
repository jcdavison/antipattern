class Api::TokensController < ApplicationController
  before_filter :authenticate_user!

  def show
    if current_user.wallet
      head :ok
    else
      head :forbidden
    end
  end
end

class Api::UsersController < ApplicationController
  before_filter :authenticate_user!, except: [:index]
  respond_to :json

  def index
    @users = User.first(20).sample(10)
    render 'api/users/index'
  end
end

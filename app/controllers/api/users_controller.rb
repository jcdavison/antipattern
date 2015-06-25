class Api::UsersController < ApplicationController
  before_filter :authenticate_user!, except: [:index]
  respond_to :json

  def index
    @users = User.first(30).sample(15)
    render 'api/users/index'
  end
end

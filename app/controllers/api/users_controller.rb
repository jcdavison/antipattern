class Api::UsersController < ApplicationController
  before_filter :authenticate_user!, except: [:index]
  respond_to :json

  def index
    @users = User.first(30).sample(15)
    render 'api/users/index'
  end

  private 
    def user_profile_params 
      params.require(:user).permit(:email)
    end

    def primary_notif_channel
      NotificationChannel.find_by_name PRIMARY_CHANNEL_NAME
    end
end

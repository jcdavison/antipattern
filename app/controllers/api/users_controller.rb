class Api::UsersController < ApplicationController
  before_filter :authenticate_user!, except: [:index]
  respond_to :json

  def index
    @users = User.first(30).sample(15)
    render 'api/users/index'
  end

  def update
    # @user = User.find_by_id(current_user.id)
    # if @user.update_attributes(user_profile_params) && update_notification_status
    #   render json: {update: true}
    # else 
    #   render json: {update: false}
    # end
  end

  private 
    def user_profile_params 
      params.require(:user).permit(:email)
    end

    # def update_notification_status 
    #   if params[:user][:subscribe_to].match /true/
    #     primary_notif_channel.subscribers << current_user unless primary_notif_channel.subscribers.include? current_user
    #   elsif params[:user][:subscribe_to].match /false/
    #     primary_notif_channel.subscribers.delete current_user
    #   end
    # end

    def primary_notif_channel
      NotificationChannel.find_by_name PRIMARY_CHANNEL_NAME
    end
end

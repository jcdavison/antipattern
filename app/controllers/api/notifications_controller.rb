class Api::NotificationsController < ApplicationController
  before_filter :authenticate_user!, except: [:index]

  def index
    channels = NotificationChannel.all.map do |channel|
      channel.to_waffle.attributes!.merge({text: channel.name })
    end   
    render json: { channels: channels}
  end
end

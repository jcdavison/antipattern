class Api::SubscriptionsController < ApplicationController
  before_filter :authenticate_user!, except: [:index]

  def index
    subscriptions = current_user.notification_channels.map do |channel|
      channel.to_waffle.attributes!.merge({text: channel.name})
    end
    render json: { subscriptions: subscriptions}
  end

  def update
    remove_from_all current_user
    subscribe_to current_user, params[:channel_ids]
    render json: { subscribedTo: params[:channel_ids] }
    rescue 
      render json: { subscribedTo: [] }
  end

  private
    def remove_from_all user
      NotificationChannel.includes(:subscribers).each do |channel|
        subscribers = channel.subscribers
        channel_user = subscribers.find_by_id(user.id)
        if channel_user
          subscribers.delete channel_user
        end
      end
    end

    def subscribe_to user, channel_ids
      channel_ids.each do |id|
        NotificationChannel.find_by_id(id).subscribers << user
      end
    end
end

class Notifier
  attr_accessor :recipients, :notification_channels, :code_review, :notification_mailer

  def initialize opts = {}
    @recipients = {}
    @code_review = opts[:code_review]
    @notification_channels = opts[:code_review].notification_channels || []
    @notification_mailer = NotificationMailer
    route_subscribers
    notify_new_code_review
  end

  def route_subscribers
    notification_channels.each do |notification_channel|
      notification_channel.subscribers.each do |subscriber|
        route_subscriber subscriber, notification_channel.name
      end
    end
  end

  def route_subscriber subscriber, notification_channel_name
    current_recipient = recipients[subscriber.id.to_s.to_sym]
    if current_recipient
      current_recipient[:notification_channels] +=  ", #{notification_channel_name}"
    else
      recipients[subscriber.id.to_s.to_sym] = { subscriber: subscriber, notification_channels: "#{notification_channel_name}" } 
    end
  end

  def notify_new_code_review
    recipients.each do |recipient_id, recipient|
      opts = {code_review: code_review, recipient: recipient[:subscriber], topics: recipient[:notification_channels]}
      notification_mailer.new_code_review(opts).deliver
    end
  end
end

class NotificationChannel < ActiveRecord::Base
  has_and_belongs_to_many :subscribers, class_name: 'User'

  def self.send! args = nil
    self.find_by_name(args[:name]).execute(args)
  end

  def execute args
    subscribers.inject(0) do |notification_count, subscriber|
      args.merge! subscriber: subscriber
      next notification_count if should_skip? args
      NotificationMailer.send(name.to_sym, args).deliver
      notification_count += 1
    end
  end

  def should_skip? args
    args[:skip_user] && args[:skip_user].id == args[:subscriber].id
  end

  def self.subscribe args
    NotificationChannel.find_by(name: args[:name]).subscribers << args[:subscriber]
  end
end

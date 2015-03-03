class NotificationChannel < ActiveRecord::Base
  has_and_belongs_to_many :subscribers, class_name: 'User'

  def self.send! args = nil
    self.find_by_name(args[:name]).execute(args)
  end

  def execute args
    subscribers.each do |subscriber|
      args.merge! subscriber: subscriber
      NotificationMailer.send(name.to_sym, args).deliver
    end
  end

  def self.subscribe args
    NotificationChannel.find_by(name: args[:name]).subscribers << args[:subscriber]
  end
end

class NotificationChannel < ActiveRecord::Base
  has_and_belongs_to_many :subscribers, class_name: 'User', foreign_key: 'id'
end

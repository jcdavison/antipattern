class CodeReview < ActiveRecord::Base
  include WaffleHelper

  belongs_to :user
  validates_presence_of :user_id
  has_many :offers

  acts_as_taggable
  acts_as_taggable_on :topics

  scope :all_active, -> {where(deleted: false)}

  def has_offers?
    ! offers.empty?
  end

  def notify_subscribers 
    NotificationChannel.send! name: 'new_code_review', code_review: self, skip_user: user
  end

  def self.avail_topics
    %w(http javascript java c# php android jquery python html c++ ios mysql css sql asp.net objective-c .net swift ruby-on-rails c ruby angular.js react.js ember.js backbone.js r security devops node.js html5 performance algorithms git wordpress rails chef react-native crypto-currency bitcoin).sort
  end

  def package_with_associations
    self.to_waffle.attributes!
      .merge(topics: self.topic_list.join(', '))
      .merge(user: self.user.to_waffle.attributes!)
  end

  def display_attributes
    self.attributes.keys
  end

  def notification_channels
    NotificationChannel.where name: topics.map(&:name)
  end
end

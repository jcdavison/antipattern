class CodeReview < ActiveRecord::Base
  include JsonHelper
  belongs_to :user
  validates_presence_of :detail, :user_id, :title
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

  def self.avail_tags
    %w(javascript java c# php android jquery python html c++ ios mysql css sql asp.net objective-c .net swift ruby-on-rails c ruby angular.js react.js ember.js backbone.js r security devops node.js html5 performance algorithms git)
  end

  def package_with_associations
    self.to_builder.attributes!
      .merge(topics: self.topic_list.join(', '))
      .merge(user: self.user.to_builder.attributes!)
  end

  def display_attributes
    self.attributes.keys
  end
end

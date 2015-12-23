class CodeReview < ActiveRecord::Base
  include WaffleHelper
  include OctoHelper

  belongs_to :user
  validates_presence_of :user_id
  has_many :offers
  has_many :comments
  has_many :votes, as: :voteable

  acts_as_taggable
  acts_as_taggable_on :topics

  scope :all_active, -> {where(deleted: false)}
  scope :all_public, -> {where(is_private: false)}
  scope :all_private, -> {where(is_private: true)}
  scope :reverse_order, -> {order('created_at DESC')}
  before_create :verify_repo_privacy
  after_create :build_hook!

  def has_offers?
    ! offers.empty?
  end

  def notify_subscribers 
    NotificationChannel.send! name: 'new_code_review', code_review: self, skip_user: user
  end

  def self.avail_topics
    %w(http javascript java c# php android jquery python html c++ ios mysql css sql asp.net objective-c .net swift ruby-on-rails c ruby angular.js react.js ember.js backbone.js r security devops node.js html5 performance algorithms git wordpress rails chef react-native crypto-currency bitcoin laravel clojure clojurescript plsql haskell).sort
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

  def verify_repo_privacy
    repository = get_repo token: user.octo_token, author: author, repo: repo
    self.is_private = repository[:private]
  end

  def collaborators_key
    "#{self.class.to_s}-collaborators-#{id}"
  end

  def collaborators
    Rails.cache.read(collaborators_key) || set_collaborators
  end

  def set_collaborators
    Rails.cache.write collaborators_key, get_collaborators(token: user.octo_token, author: author, repo: repo)
  end

  def self.clear_all_collaborators
    all_private.each {|code_review| Rails.cache.write code_review.collaborators_key, nil }.map do |code_review|
      [ code_review.id, Rails.cache.read(code_review.collaborators_key) ]
    end
  end

  def self.update_all_collaborators
    all_private.each {|code_review| code_review.set_collaborators }.map do |code_review|
      [ code_review.id, code_review.collaborators ]
    end
  end

  def build_hook!
    create_webhook opts unless valid_hook?
  end

  def valid_hook?
    has_valid_octo_webhook? opts
  end

  def clear_hooks!
    clear_octo_hooks! opts
  end

  def opts
    {author: author, token: user.octo_token, repo: repo, id: id}
  end
end

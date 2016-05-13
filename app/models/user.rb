include WaffleHelper
include QueryHelper

class User < ActiveRecord::Base
  TEMP_EMAIL_PREFIX = 'change@me'
  TEMP_EMAIL_REGEX = /\Achange@me/
  devise :database_authenticatable, :registerable, 
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable
  validates_format_of :email, :without => TEMP_EMAIL_REGEX, on: :update

  has_many :identities, dependent: :destroy
  has_many :code_reviews, dependent: :destroy
  has_many :offers, dependent: :destroy
  has_many :comment_feeds
  has_one :wallet, dependent: :destroy
  has_and_belongs_to_many :notification_channels, dependent: :destroy

  def self.find_for_oauth(auth, signed_in_resource = nil)
    identity = Identity.build_for_oauth(auth)
    user = signed_in_resource ? signed_in_resource : identity.user
    if user.nil?
      if auth.provider.match /google_oauth2|github|github_full_scope/
        email = auth.info.email
      else
        email_is_verified = auth.info.email && (auth.info.verified || auth.info.verified_email)
        email = auth.info.email if email_is_verified
      end
      user = User.where(:email => email).first if email
      if user.nil?
        user = User.new(
          name: auth.extra.raw_info.name,
          email: (!email.nil? && !email.empty?) ? email : "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com",
          password: Devise.friendly_token[0,20],
          github_profile: auth.info.urls.GitHub
        )
        user.save!
      end
    end
    if user.profile_pic.nil?
      user.profile_pic = auth.info.image
      user.save
    end

    identity.token = auth["credentials"]["token"]
    identity.save!

    if identity.user != user
      identity.user = user
      identity.save!
    end
    user
  end

  def email_verified?
    self.email && self.email !~ TEMP_EMAIL_REGEX
  end

  def subscribe_new_code_reviews
    NotificationChannel.subscribe name: 'new_code_review', subscriber: self
  end

  def display_attributes
    %w(name profile_pic github_profile github_username id)
  end

  def github_username
    github_profile.split("/").last
  end

  def octo_token
    identities.last.token
  rescue
    ENV['GITHUB_PERSONAL_ACCESS_TOKEN']
  end

  def has_private_repo_scope?
    identities.first.private_scope
  end

  def private_code_review_access_ids
    all_accessible_private_code_reviews(github_username).map {|code_review| code_review['id'] }
  end

  def comments_cache_key
    "user_id_#{id}_comments"
  end
end

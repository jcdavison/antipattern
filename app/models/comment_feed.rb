class CommentFeed < ActiveRecord::Base
  validates_presence_of :user_id, :repository, :url_slug, :github_entity
  belongs_to :user

  def self.build_from opts
    details = { user_id: opts[:user_id],
                repository: opts[:repository],
                github_entity: opts[:github_entity] }
    details[:url_slug] = SecureRandom.hex 
    CommentFeed.new(details).save
  end

  def display_attributes
    self.attributes.keys.push('url')
  end

  def url
    "/comment-feeds/#{url_slug}"
  end
end

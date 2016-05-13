require 'rails_helper'

RSpec.describe CommentFeed, :type => :model do
  it '.build_from(details)' do
    feed_details = { user_id: 1,
                        repository: 'foo-repo',
                        github_entity: 'foo-person' }
    comment_feed = CommentFeed.build_from(feed_details)
    comment_feed.save
    expect(comment_feed.url_slug.nil?).to eq false
  end
end

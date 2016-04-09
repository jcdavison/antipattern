class Comment < ActiveRecord::Base
  include WaffleHelper

  belongs_to :code_review
  has_many :votes, as: :voteable
  validates_uniqueness_of :github_id
  after_create :create_sentiments
  has_and_belongs_to_many :sentiments

  def display_attributes
    [:id, :github_id, :body, :vote_count]
  end

  def votes_on_comments
    votes.select do |vote|
      vote.sentiment_id.nil?
    end
  end

  def votes_on_sentiments
    votes.select do |vote|
      ! vote.sentiment_id.nil?
    end
  end

  def vote_count
    count_votes votes_on_comments
  end

  def sentiments_vote_summary
    SentimentAggregator.collate votes_on_sentiments
  end

  def count_votes selected_votes
    selected_votes.inject({upVotes: 0, downVotes: 0}) do |score, vote|
      score[:upVotes] += vote.value if vote.value == 1
      score[:downVotes] += vote.value if vote.value == -1
      score
    end
  end

  def create_sentiments
    Sentiment.for_comments.each do |sentiment|
      sentiments << sentiment
    end
  end

  def sentiments_as_opts
    sentiments.inject([]) do |collection, sentiment|
      collection.push({name: sentiment.name, id: sentiment.id})
    end
  end
end

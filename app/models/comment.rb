class Comment < ActiveRecord::Base
  include WaffleHelper

  acts_as_taggable
  acts_as_taggable_on :sentiments
  SENTIMENTS = 'informative, succint, ambiguous, kind, motivating, harsh'

  belongs_to :code_review
  has_many :votes, as: :voteable
  validates_uniqueness_of :github_id
  after_create :create_sentiments

  def display_attributes
    [:id, :github_id, :body, :vote_count]
  end

  def vote_count
    votes.inject({upVotes: 0, downVotes: 0}) do |score, vote|
      score[:upVotes] += vote.value if vote.value == 1
      score[:downVotes] += vote.value if vote.value == -1
      score
    end
  end

  def create_sentiments
    self.sentiment_list = SENTIMENTS
    save
  end

  def sentiments_as_opts
    sentiments.inject([]) do |collection, sentiment|
      collection.push({name: sentiment.name, id: sentiment.id})
    end
  end
end

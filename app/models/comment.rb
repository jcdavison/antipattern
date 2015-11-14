class Comment < ActiveRecord::Base
  include WaffleHelper

  belongs_to :code_review
  has_many :votes, as: :voteable
  validates_uniqueness_of :github_id

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
end

class CommentSentimentVoter
  class InvalidVoteAttempt < StandardError ; end
  class MultiplePriorVotes < StandardError ; end

  def self.register_vote new_vote, user
    raise InvalidVoteAttempt if has_voted?(new_vote, user)
    vote_to_switch = vote_to_change(new_vote, user)
    if vote_to_switch
      change_vote!(vote_to_switch)
    else
      Vote.create(new_vote)
    end
  end

  def self.has_voted? new_vote, user
    duplicate_votes = self.duplicate_votes(new_vote, user) 
    raise MultiplePriorVotes if duplicate_votes.length > 1
    ! duplicate_votes.empty?
  end

  def self.duplicate_votes new_vote, user, switch = 1
    Vote.where(user_id: user.id, voteable_id: new_vote[:voteable_id]).where.not(sentiment_id: nil).select do |vote|
      vote.sentiment.id == new_vote[:sentiment_id] && (vote.value * switch) == new_vote[:value]
    end
  end

  def self.change_vote! existing_vote
    existing_vote.switch_value!
  end

  def self.vote_to_change  new_vote, user
    votes_to_change = self.duplicate_votes(new_vote, user, -1) 
    raise MultiplePriorVotes if votes_to_change.length > 1
    votes_to_change.first
  end
end

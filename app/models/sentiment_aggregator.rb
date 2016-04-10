class SentimentAggregator
  def self.collate votes, user
    sentiment_votes_map = build_sentiment_votes_map votes
    tally_votes votes, sentiment_votes_map, user
  end

  def self.build_sentiment_votes_map votes
    votes.inject(comment_votes_map) do |votes_by_sentiment, vote|
      votes_by_sentiment
    end
  end

  def self.tally_votes votes, sentiment_votes_map, user
    votes.each do |vote|
      sentiment_name = vote.sentiment.name
      if vote.value == 1
        sentiment_votes_map[sentiment_name][:has_up_vote] = true if user.id == vote.user_id
        sentiment_votes_map[sentiment_name][:up_votes] += vote.value
      elsif vote.value == -1
        sentiment_votes_map[sentiment_name][:has_down_vote] = true if user.id == vote.user_id
        sentiment_votes_map[sentiment_name][:down_votes] += vote.value 
      end
    end
    sentiment_votes_map
  end

  def self.comment_votes_map
    Sentiment.for_comments.inject({}) do |votes_map, sentiment|
      votes_map[sentiment.name] = {up_votes: 0, down_votes: 0, has_up_vote: false, has_down_vote: false}
      votes_map
    end
  end
end

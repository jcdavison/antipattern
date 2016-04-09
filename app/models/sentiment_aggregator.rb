class SentimentAggregator
  def self.collate votes
    aggregate_votes build_sentiment_votes_map votes
  end

  def self.build_sentiment_votes_map votes
    votes.inject({}) do |votes_by_sentiment, vote|
      if votes_by_sentiment[vote.sentiment.name]
        votes_by_sentiment[vote.sentiment.name].push vote
      else
        votes_by_sentiment[vote.sentiment.name] = [vote]
      end
      votes_by_sentiment
    end
  end

  def self.aggregate_votes sentiment_votes_map
    sentiment_votes_map.each do |sentiment, votes|
      sentiment_votes_map[sentiment] = tally_votes votes
    end
  end

  def self.tally_votes votes
    votes.inject({up_votes: 0, down_votes: 0}) do |votes_tally, vote|
      if vote.value == 1
        votes_tally[:up_votes] += vote.value
      elsif vote.value == -1
        votes_tally[:down_votes] += vote.value 
      end
      votes_tally
    end
  end
end

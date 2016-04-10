require 'rails_helper'

RSpec.describe CommentSentimentVoter, :type => :model do
  context '.register_vote' do
    context 'user has not voted on sentiment' do
      it 'creates a new vote' do
        vote = { voteable_type: "Comment",
                      voteable_id: 1,
                      value: -1,
                      user_id: 1,
                      sentiment_id: 1 }
        user = OpenStruct.new id: 1
        expect(Vote).to receive(:create)
        CommentSentimentVoter.register_vote vote, user
      end
    end

    context 'voting on same sentiment, different comment' do
      it 'creates new votes' do
        Sentiment.create name: 'informative'
        vote = { voteable_type: "Comment",
                      voteable_id: 1,
                      value: -1,
                      user_id: 1,
                      sentiment_id: Sentiment.first.id }
        other_vote = { voteable_type: "Comment",
                      voteable_id: 2,
                      value: -1,
                      user_id: 1,
                      sentiment_id: Sentiment.first.id }
        user = OpenStruct.new id: 1
        CommentSentimentVoter.register_vote vote, user
        expect(Vote).to receive(:create)
        CommentSentimentVoter.register_vote other_vote, user
      end
    end

    context 'user attempting to replicate 1/-1 vote' do
      it 'raises' do
        Sentiment.create name: 'happy'
        user = OpenStruct.new id: 1
        vote = { voteable_type: "Comment",
                      voteable_id: 1,
                      value: -1,
                      user_id: 1,
                      sentiment_id: Sentiment.first.id }
        Vote.create vote
        expect{CommentSentimentVoter.register_vote(vote, user)}.to raise_error(CommentSentimentVoter::InvalidVoteAttempt)
      end

      context 'multiple prior votes exits for same criterium' do
        it 'raises' do
          Sentiment.create name: 'happy'
          user = OpenStruct.new id: 1
          vote = { voteable_type: "Comment",
                        voteable_id: 1,
                        value: -1,
                        user_id: 1,
                        sentiment_id: Sentiment.first.id }
          Vote.create vote
          Vote.create vote
          expect{CommentSentimentVoter.register_vote(vote, user)}.to raise_error(CommentSentimentVoter::MultiplePriorVotes)
        end
      end
    end

    context 'user attempts to switch a vote' do
      context 'one prior vote to switch' do
        it 'switches the vote value' do
          Sentiment.create name: 'happy'
          user = OpenStruct.new id: 1
          vote_opts = { voteable_type: "Comment",
                        voteable_id: 1,
                        value: -1,
                        user_id: 1,
                        sentiment_id: Sentiment.first.id }
          vote = Vote.new vote_opts
          vote.save
          vote_opts[:value] = 1
          expect(vote.value).to eq -1 
          CommentSentimentVoter.register_vote(vote_opts, user)
          vote.reload
          expect(vote.value).to eq 1
        end
      end

      context 'multiple votes to switch' do
        it 'raises' do
          Sentiment.create name: 'happy'
          user = OpenStruct.new id: 1
          vote = { voteable_type: "Comment",
                        voteable_id: 1,
                        value: -1,
                        user_id: 1,
                        sentiment_id: Sentiment.first.id }
          Vote.create vote
          Vote.create vote
          vote[:value] = 1
          expect{CommentSentimentVoter.register_vote(vote, user)}.to raise_error(CommentSentimentVoter::MultiplePriorVotes)
        end
      end
    end
  end
end

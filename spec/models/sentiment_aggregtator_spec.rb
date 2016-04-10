require 'rails_helper'

RSpec.describe SentimentAggregator, :type => :model do
  before do
    Sentiment.build_comment_emotions
    @user = OpenStruct.new id: 3 
    @other_user = OpenStruct.new id: 4 
    vote = OpenStruct.new(value: 1, sentiment: OpenStruct.new(name: 'informative'), user_id: @user.id)
    other_vote = OpenStruct.new(value: -1, sentiment: OpenStruct.new(name: 'informative'), user_id: @other_user.id)
    @user_sentiments = SentimentAggregator.collate([vote, other_vote], @user)
    @other_user_sentiments = SentimentAggregator.collate([vote, other_vote], @other_user)
  end

  context '.collate' do
    context 'votes = []' do
      it 'returns empty values' do
        aggregated_sentiments = SentimentAggregator.collate([], @user)
      end
    end

    context 'votes = [Vote, OtherVote]' do
      context 'aggregated for user' do
        it 'sentiment_1.up_votes == 1' do
          expect(@user_sentiments['informative'][:up_votes]).to eq 1
        end

        it 'sentiment_1.down_votes == -1' do
          expect(@user_sentiments['informative'][:down_votes]).to eq -1
        end

        it 'sentiment_2.down_votes == -1' do
          expect(@user_sentiments['succint'][:down_votes]).to eq 0
        end

        it 'sentiment1.has_upvote' do
          expect(@user_sentiments['informative'][:has_up_vote]).to eq true 
        end
      end

      context 'aggregated for other_user' do
        it 'sentiment2.has_down_vote' do
          expect(@other_user_sentiments['informative'][:has_down_vote]).to eq true 
        end
      end
    end
  end
end

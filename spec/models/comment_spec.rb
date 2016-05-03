require 'rails_helper'

RSpec.describe Comment, :type => :model do
  VOTES_ON_COMMENTS = 4
  VOTES_TALLEY_EXAMPLE = {"informative"=>{:up_votes=>1, :down_votes=>-1, :has_up_vote=>false, :has_down_vote=>false}, "succint"=>{:up_votes=>1, :down_votes=>-1, :has_up_vote=>false, :has_down_vote=>false}, "compassionate"=>{:up_votes=>1, :down_votes=>-1, :has_up_vote=>false, :has_down_vote=>false}, "motivating"=>{:up_votes=>1, :down_votes=>-1, :has_up_vote=>false, :has_down_vote=>false}}

  context 'happy behaviors' do
    before :each do
      Sentiment.build_comment_emotions
      @comment = create :comment
      VOTES_ON_COMMENTS.times do |n|
        create :vote, voteable_id: @comment.id, voteable_type: 'Comment', value: n.even? ? 1: -1, user_id: n + 1
      end
      @comment.sentiments.each_with_index do |sentiment, n|
        create :vote, voteable_id: @comment.id, value: (n+1).even? ? 1: -1, user_id: n + 1, sentiment_id: sentiment.id
      end
    end

    it 'is valid' do
      expect(@comment.valid?).to eq true
    end

    it '#vote_count' do
      expect(@comment.vote_count[:upVotes]).to eq 2
    end

    it '#votes_on_comments' do
      expect(@comment.votes_on_comments.length).to eq VOTES_ON_COMMENTS
    end

    it '#votes_on_sentiments' do
      expect(@comment.votes_on_sentiments.length).to eq @comment.sentiments.length
    end

    it '#sentiments_vote_summary' do
      user = OpenStruct.new id: 123
      expect(@comment.sentiments_vote_summary(user)).to eq VOTES_TALLEY_EXAMPLE 
    end
  end
end

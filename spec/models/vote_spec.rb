require 'rails_helper'

RSpec.describe Vote, :type => :model do

  context 'happy behaviors' do
    before :each do
      @vote = build :vote
    end

    it 'value = 1 || -1' do
      [ 1, -1].each do |int|
        @vote.value = int
        expect(@vote.valid?).to eq true
      end
    end

    it 'value 2 || nil ' do
      [ 2, nil].each do |int|
        @vote.value = int
        expect(@vote.valid?).to eq false
      end
    end

    it '#switch_value!' do
      @vote.switch_value!
      expect(@vote.value).to eq -1
    end

    context 'uniqueness conditions' do
      it 'one comment one vote' do
        @vote.save
        duplicate_vote = build :vote
        duplicate_vote.valid?
        expect(duplicate_vote.errors[:user_id].any? {|e| e == "has already been taken" }).to eq true
      end

      it 'one comment MANY attribute votes' do
        @vote.save
        duplicate_vote = build :vote, sentiment_id: 1
        duplicate_vote.valid?
        expect(duplicate_vote.errors[:user_id].any? {|e| e == "has already been taken" }).to eq false
      end
    end
  end
end

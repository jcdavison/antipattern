require 'rails_helper'

RSpec.describe ReviewableCommit, :type => :model do
  let(:user) { FactoryGirl.create :user, identities: [FactoryGirl.create(:identity)]}
  let(:code_review) { FactoryGirl.create :code_review, user: user}
  let(:commit) { ReviewableCommit.new(code_review) }

  context 'private scoped user' do
    context 'useful information required by the client' do
      context '#content' do
        it ':files' do
          expect(commit.content[:files].length).to eq 1
          expect(commit.content[:files].first[:filename]).to eq 'test.rb'
        end

        it ':info' do
          expect(commit.content[:info][:message]).to eq 'test test test' 
        end
      end
    end
  end
end

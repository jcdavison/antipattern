require 'rails_helper'

RSpec.describe User, :type => :model do
  let(:user) { FactoryGirl.create :user}

  context 'whoo the foo?' do
    it '#comments_cache_key' do
      user = FactoryGirl.create :user
      expect(user.comments_cache_key).to eq "user_id_#{user.id}_comments" 
    end
  end
end

require 'rails_helper'

RSpec.describe UserCommentsList do
  context 'init methods' do
    before(:each) do
      @user = FactoryGirl.create :user, identities: [FactoryGirl.create(:identity)]
      user_opts = {octo_token: @user.octo_token, user_comments_cache_key: @user.comments_cache_key }
      @user_comments_list = UserCommentsList.new user_opts
    end

    it '#org_names' do
      expect(@user_comments_list.org_names.include?('AntiPatternIO')).to eq true
    end

    it '#org_repos' do
      expect(@user_comments_list.org_repos.any? {|obj| obj[:name] == 'test-repo' }).to eq true
    end

    it '#user_repos' do
      expect(@user_comments_list.user_repos.any? {|obj| obj[:name] == 'bengaltigers' }).to eq true
    end

    it '#all_repos' do
      ['test-repo', 'bengaltigers'].each do |repo_name|
        expect(@user_comments_list.all_repos.any? {|obj| obj[:name] == repo_name }).to eq true
      end
    end

    it '#comment_objects' do
      all_commit_ids = @user_comments_list.all_comments.map {|c| c[:comment][:commit_id] }.uniq
      aggregated_commit_ids = @user_comments_list.comment_objects.keys
      expect(all_commit_ids.sort == aggregated_commit_ids.sort).to eq true
    end

    it '#clear_user_cache' do
      expect(Rails.cache.read(@user.comments_cache_key).nil?).to eq false
      expect(@user_comments_list.clear_user_cache(@user.comments_cache_key)).to eq true
    end

    it '#write_to_user_cache' do
      @user_comments_list.write_to_user_cache @user.comments_cache_key
      expect(Rails.cache.read(@user.comments_cache_key) == @user_comments_list.comment_objects).to eq true
    end
  end
end

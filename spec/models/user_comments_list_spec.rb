require 'rails_helper'

RSpec.describe UserCommentsList, :type => :model do
  context 'init methods' do
    before(:all) do
      user = FactoryGirl.create :user, identities: [FactoryGirl.create(:identity)]
      @user_comments_list = UserCommentsList.new client: build_octoclient(user.octo_token)
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
      expect(@user_comments_list.comment_objects.all? {|obj| obj.keys == [:comment, :repo]}).to eq true
    end
  end
end

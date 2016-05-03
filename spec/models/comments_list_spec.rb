require 'rails_helper'

RSpec.describe CommentsList do
  context 'init methods' do
    before(:each) do
      Sentiment.build_comment_emotions
      identity = FactoryGirl.create(:identity)
      @user = FactoryGirl.create :user, identities: [ identity ]
      client = build_octo_client @user.octo_token
      opts = {client: client, repo: 'antipattern', user: 'AntiPatternIO'}
      @comments_list = CommentsList.new opts
    end

    it '#all_comments' do
      binding.pry
      expect(@comments_list.raw_comments.first.to_h.keys).to eq augmented_github_comment_keys
    end

    it '#comment_records' do
      comment_structure = @comments_list.comment_records.map {|c| c.keys }
      expect(comment_structure.all? {|c| c == [:comment, :repo, :sentiments, :votes]}).to eq true
    end

    it '#comments' do
      expect(@comments_list.comments.keys.any? {|key| key == "207071c3344f6eadac6092aa435c67c1726f3436"}).to eq true
    end
  end
end

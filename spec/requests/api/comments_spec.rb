require 'rails_helper'

RSpec.describe 'Branches Controller' do

  let(:user) { FactoryGirl.create :user }

  context 'un-authenticated user', :skip => true do
    it 'redirect' do
      post "/api/comments", {comment: { some_key: 'foo' }}
      expect(response).to redirect_to root_path
    end
  end

  context 'authenticated user', :skip => true do
    context 'malformed comment' do
      it '200' do
        login_as user
        post "/api/comments", {comment: {}}
        expect(response.status).to eq 401
      end
    end
  end
end

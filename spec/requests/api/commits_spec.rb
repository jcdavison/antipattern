require 'rails_helper'

RSpec.describe Api::CommitsController do

  let(:user) { FactoryGirl.create :user }

  context 'un-authenticated user' do
    it 'redirect' do
      get "/api/commits?repod_id=1"
      expect(response).to redirect_to root_path
    end
  end

  context 'authenticated user' do
    context 'resource does not exist' do
      it '401' do
        login_as user
        get "/api/commits?repo_id=1&branch=foo"
        expect(response.status).to eq 401
      end
    end
  end
end

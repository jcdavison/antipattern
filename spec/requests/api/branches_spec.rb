require 'rails_helper'

RSpec.describe 'Branches Controller' do

  let(:user) { FactoryGirl.create :user }

  context 'authenticated user' do
    it '200' do
      login_as user
      get "/api/branches?id=1"
      expect(response.status).to eq 200
    end
  end

  context 'un-authenticated user' do
    it 'redirect' do
      get "/api/branches?id=1"
      expect(response).to redirect_to root_path
    end
  end
end

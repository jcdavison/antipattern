require 'rails_helper'

RSpec.describe Api::EntitiesController do

  let(:user) { FactoryGirl.create :user }

  context 'un-authenticated user' do
    it 'redirect' do
      get "/api/entities?id=1"
      expect(response).to redirect_to root_path
    end
  end

  context 'authenticated user' do
    it '200' do
      login_as user
      get "/api/entities"
      expect(response.status).to eq 200
    end
  end
end

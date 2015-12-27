require 'rails_helper'

RSpec.describe 'Code Review Controller' do
  context 'authenticated user' do

    context "GET '/code_reviews'" do
      it 'renders stake_farm' do
        get '/code_reviews'
        expect(response).to render_template 'layouts/application'
      end
    end
  end

  context 'un-authenticated user' do
    context "GET '/'" do
      it 'renders splash' do
        get '/'
        expect(response).to render_template 'layouts/application'
      end
    end
  end
end


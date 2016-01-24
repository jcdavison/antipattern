require 'rails_helper'

RSpec.describe 'Code Review Controller' do
  context 'authenticated user' do
    context "GET '/code_reviews/:id'" do
      let(:user) { FactoryGirl.create :user, identities: [FactoryGirl.create(:identity)]}
      before do
        allow_any_instance_of(CodeReview).to receive(:verify_repo_privacy).and_return nil 
        allow_any_instance_of(CodeReview).to receive(:build_hook!).and_return nil 
        @code_review = FactoryGirl.create :code_review, user: user, is_private: true
      end

      context 'private code review' do
        context 'unauthenticated user' do
          it 'redirects /code-reviews' do
            get "/code-reviews/#{@code_review.id}"
            expect(response).to redirect_to code_reviews_path
          end
        end

        context 'authenticated user HAS ACCESS to this repo' do
          it 'displays the code review' do
            login_as user
            allow_any_instance_of(User).to receive(:private_code_review_access_ids).and_return([@code_review.id])
            get "/code-reviews/#{@code_review.id}"
            expect(response).to render_template :show
          end
        end

        context 'authenticated user DOES NOT HAVE ACCESS to this repo' do
          it 'redirects /code-reviews' do
            login_as user
            allow_any_instance_of(User).to receive(:private_code_review_access_ids).and_return([nil])
            get "/code-reviews/#{@code_review.id}"
            expect(response).to redirect_to code_reviews_path
          end
        end
      end
    end
  end
end

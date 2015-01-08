class HomeController < ApplicationController
  before_filter :authenticate_user!, except: :splash
  layout :choose_layout

  def index
    all_review_requests
  end

  def splash
    all_review_requests
  end

  def choose_layout
    user_signed_in? ? 'authenticated_app' : 'application'
  end

  private

  def all_review_requests
    @review_requests = ReviewRequest.all
  end
end


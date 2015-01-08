class HomeController < ApplicationController
  before_filter :authenticate_user!, except: :splash

  def index
    all_review_requests
  end

  def splash
    all_review_requests
  end

  private

    def all_review_requests
      @review_requests = ReviewRequest.all
    end
end


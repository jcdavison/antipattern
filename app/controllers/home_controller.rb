class HomeController < ApplicationController
  layout :set_layout

  def index
    all_review_requests
  end

  def splash
    all_review_requests
  end

  private

    def all_review_requests
      @review_requests = ReviewRequest.order 'created_at DESC'
    end

    def set_layout 
      case action_name
      when 'splash'
        'splash'
      else
        'application'
      end
    end
end

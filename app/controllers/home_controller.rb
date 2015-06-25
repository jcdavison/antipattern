class HomeController < ApplicationController
  layout :set_layout

  def index
    all_code_reviews
  end

  def splash
    all_code_reviews
  end

  private
    def all_code_reviews
      @code_reviews = CodeReview.order 'created_at DESC'
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

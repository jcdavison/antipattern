class HomeController < ApplicationController
  include QueryHelper
  layout :set_layout

  def index
    @code_reviews = all_active_code_reviews
    @tags = CodeReview.avail_tags
  end

  private
    def set_layout 
      case action_name
        when 'splash'
          'splash'
        else
          'application'
      end
    end
end

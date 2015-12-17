include QueryHelper
class HomeController < ApplicationController
  layout :set_layout

  def index
    if current_user
      private_code_reviews = current_user.all_accessible_private_code_reviews.map do |code_review| 
        code_review.package_with_associations
      end
      @code_reviews = [ all_active_code_reviews, private_code_reviews ].flatten.sort_by {|c| c["createdAt"] }.reverse
    else
      @code_reviews = all_active_code_reviews
    end
  end

  def splash
    @users = User.first(300).shuffle.map {|u| u.to_waffle.attributes! }
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

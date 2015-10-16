include QueryHelper
class HomeController < ApplicationController
  layout :set_layout

  def index
    @code_reviews = all_active_code_reviews
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

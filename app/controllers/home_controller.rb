include QueryHelper
class HomeController < ApplicationController
  layout :set_layout

  def splash
    @users = User.first(300).shuffle.map {|u| u.to_waffle.attributes! }
  end

  private
    def set_layout 
      'splash'
    end
end

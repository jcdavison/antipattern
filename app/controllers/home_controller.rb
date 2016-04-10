include QueryHelper
class HomeController < ApplicationController
  layout :set_layout
  protect_from_forgery :except => [:exp]

  def splash
    @users = User.first(300).shuffle.map {|u| u.to_waffle.attributes! }
  end

  def exp
    render json: { response_body: 'empty'}, status: 200
  end

  private
    def set_layout 
      'splash'
    end
end

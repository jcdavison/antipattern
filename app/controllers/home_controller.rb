class HomeController < ApplicationController
  before_filter :authenticate_user!, except: :splash
  layout :choose_layout

  def index
  end

  def splash
  end

  def choose_layout
    user_signed_in? ? 'authenticated_app' : 'application'
  end
end


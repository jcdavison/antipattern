class UsersController < ApplicationController
  before_action :set_user, only: [:settings, :show, :edit, :update, :destroy, :finish_signup]

  def edit
  end

  def settings
  end

  def update
    if params[:disable_private_repos]
      current_user.disable_private_repos!
      redirect_to settings_path
    end
    rescue 
      redirect_to root_path
  end

  def finish_signup
    if request.patch? && params[:user] #&& params[:user][:email]
      if @user.update(user_params)
        sign_in(@user, :bypass => true)
        redirect_to code_reviews_path, notice: 'Your profile was successfully updated.'
      else
        @show_errors = true
      end
    end
  end

  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to root_url }
      format.json { head :no_content }
    end
  end
  
  private
    def set_user
      @user = current_user
      redirect_to code_reviews_path unless @user
    end

    def user_params
      accessible = [ :name, :email ] # extend with your own params
      accessible << [ :password, :password_confirmation ] unless params[:user][:password].blank?
      params.require(:user).permit(accessible)
    end
end

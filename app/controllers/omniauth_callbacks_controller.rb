class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def self.provides_callback_for(provider)
    class_eval %Q{
      def #{provider}
        @user = User.find_for_oauth(env["omniauth.auth"], current_user)

        if @user.persisted?
          sign_in_and_redirect @user, event: :authentication
          set_flash_message(:notice, :success, kind: "#{provider}".capitalize) if is_navigational_format?
        else
          session["devise.#{provider}_data"] = env["omniauth.auth"]
          redirect_to new_user_registration_url
        end
      end
    }
  end

  [:github, :stripe_connect].each do |provider|
    provides_callback_for provider
  end

  def after_sign_in_path_for(resource)
    if resource.email_verified?
      super resource
    else
      finish_signup_path(resource)
    end
  end

  def stripe_connect
    wallet = current_user.wallet
    if wallet
      wallet.update_attributes wallet_params
    else
      Wallet.new(wallet_params).save
    end
    redirect_to profile_path(current_user)
  end

  private
    def provider
      request.env['omniauth.auth']
    end

    def wallet_params
      { stripe_uid: provider[:uid], 
      stripe_access_token: provider[:credentials][:token], 
      stripe_refresh_token: provider[:credentials][:refresh_token], 
      stripe_publishable_key: provider[:info][:stripe_publishable_key], 
      stripe_scope: provider[:info][:scope], 
      user_id: current_user.id }
    end
end

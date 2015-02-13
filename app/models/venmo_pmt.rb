class VenmoPmt < ActiveRecord::Base
  def self.set_on_omniauth_callback provider, current_user
    token = find_by(username: provider[:info][:username])
    if token
      token.update_attributes omniauth_attributes provider, current_user
    else
      create omniauth_attributes provider, current_user
    end
  end

  def self.omniauth_attributes provider, current_user
    { username: provider[:info][:username], 
      uid: provider[:uid], 
      token: provider[:credentials][:token], 
      refresh_token: provider[:credentials][:refresh_token],
      expires_at: provider[:credentials][:expires_at],
      username: provider[:info][:username],
      profile: provider[:info][:urls][:profile],
      display_name: provider[:extra][:raw_info][:display_name],
      user_id: current_user.id }
  end
end

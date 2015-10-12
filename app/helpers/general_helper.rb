module GeneralHelper
  def github_username user
    user.github_profile.split('/').last
  end

  def render_current_user
    if current_user
      current_user.to_waffle.attributes!
    else
      nil
    end
  end
end

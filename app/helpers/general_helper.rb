module GeneralHelper
  def github_username user
    user.github_profile.split('/').last
  end
end

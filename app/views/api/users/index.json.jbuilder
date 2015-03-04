json.array! @users do |user|
  json.(user, :github_profile, :profile_pic)
end

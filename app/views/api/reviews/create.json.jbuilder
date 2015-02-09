json.review_request do
  json.(@review_request, :title, :id, :value )
  json.detail @review_request.detail
  json.user do
    json.name @review_request.user.name
    json.profile @review_request.user.github_profile
    json.profile_pic @review_request.user.profile_pic
  end
end

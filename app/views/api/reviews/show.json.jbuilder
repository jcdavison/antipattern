json.codeReview do
  json.(@code_review, :title, :id, :value, :detail)
  json.user do
    json.name @code_review.user.name
    json.profile @code_review.user.github_profile
    json.profile_pic @code_review.user.profile_pic
  end
end

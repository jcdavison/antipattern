json.code_review do
  json.(@code_review, :title, :id)
  json.detail @code_review.detail
  json.user do
    json.name @code_review.user.name
    json.profile @code_review.user.github_profile
    json.profile_pic @code_review.user.profile_pic
  end
  json.summary do
    json.members_notified @members_notified
    json.code_review_url code_review_url(@code_review)
  end
end

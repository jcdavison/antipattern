json.code_review do
  json.(@code_review, :title, :id)
  json.context @code_review.context
  json.url @code_review.url
  json.antipattern_url code_review_url(@code_review)
  json.user do
    json.name @code_review.user.name
    json.profile @code_review.user.github_profile
    json.profile_pic @code_review.user.profile_pic
  end
  # json.members_notified @members_notified
end

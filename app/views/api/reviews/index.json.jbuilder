json.array! @code_reviews do |code_review|
  json.(code_review, :context, :url, :id)
  json.created_at friendly_display code_review.created_at
  json.user do
    json.name code_review.user.name
    json.github_profile code_review.user.github_profile
    json.profile_pic code_review.user.profile_pic
  end
end

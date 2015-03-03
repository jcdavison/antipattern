json.array! @offers do |offer|
  json.(offer, :id, :code_review_id)
  json.state offer.aasm_state
  json.user do
    json.id offer.user.id
    json.name offer.user.name
    json.profile offer.user.github_profile
    json.profile_pic offer.user.profile_pic
  end
  json.code_review do
    json.display_value offer.code_review.display_value
    json.value offer.code_review.value
  end
end

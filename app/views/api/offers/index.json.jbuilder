json.array! @offers do |offer|
  json.(offer, :id, :review_request_id)
  json.state offer.aasm_state
  json.user do
    json.id offer.user.id
    json.name offer.user.name
    json.profile offer.user.github_profile
    json.profile_pic offer.user.profile_pic
  end
end

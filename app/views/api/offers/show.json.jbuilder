json.offer do
  json.(@offer, :code_review_id, :user_id)
  json.state @offer.aasm_state
end

json.offer do
  json.(@offer, :code_review_id, :user_id, :value, :karma, :note)
  json.state @offer.aasm_state
end

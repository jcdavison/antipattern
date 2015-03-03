json.offer do
  json.(@offer, :code_review_id, :user_id, :value, :karma)
  json.state @offer.aasm_state
end

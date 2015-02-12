json.offer do
  json.(@offer, :review_request_id, :user_id)
  json.state @offer.aasm_state
end

json.code_review do
  json.(@code_review, :title, :id, :display_value )
  json.detail @code_review.detail
end

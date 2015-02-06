json.code_review do
  json.(@code_review, :title, :id, :display_value )
  json.detail_html markdown_to_html @code_review.detail
  json.detail_raw @code_review.detail
end

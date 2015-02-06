json.code_review do
  json.(@code_review, :title, :id, :value )
  json.detailHtml markdown_to_html @code_review.detail
  json.detailRaw @code_review.detail
end

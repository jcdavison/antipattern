module ReviewRequestHelper
  def markdown_to_html content
    Redcarpet::Markdown.new(Redcarpet::Render::HTML, fenced_code_blocks: true).render(content).html_safe
  end

  def is_owner_of? args
    current_user.id == args[:review_request].user.id
  end

  def has_offered? args
    args[:review_request].offers.any? { |offer| offer.user_id == current_user.id }
  end

  def owned_by_current_user args
    args[:offers].select { |offer| offer.user_id == current_user.id }
  end
end

module ReviewRequestHelper
  def markdown_to_html content
    Redcarpet::Markdown.new(Redcarpet::Render::HTML, fenced_code_blocks: true).render(content).html_safe
  end

  def is_owner_of? args
    args[:current_user] ? args[:current_user].id == args[:review_request].user.id : false
  end
end

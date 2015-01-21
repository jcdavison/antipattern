module ReviewRequestHelper
  def markdown_to_html content
    Redcarpet::Markdown.new(Redcarpet::Render::HTML).render(content).html_safe
  end
end

module ReviewRequestHelper
  def markdown_to_html content
    Redcarpet::Markdown.new(Redcarpet::Render::HTML, fenced_code_blocks: true).render(content).html_safe
  end
end

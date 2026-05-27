module ApplicationHelper
  def markdown(text)
    return "" if text.blank?

    renderer = Redcarpet::Render::HTML.new(
      hard_wrap: true,
      no_images: true,
      safe_links_only: true
    )
    md = Redcarpet::Markdown.new(renderer,
      no_intra_emphasis: true,
      strikethrough: true
    )
    md.render(text).html_safe
  end
end

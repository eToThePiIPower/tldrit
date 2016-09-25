require 'redcarpet'

module ApplicationHelper
  def markdown(text)
    options = {
      autolink: true,
      filter_html: true,
      hard_wrap: true,
      link_attributes: { rel: 'nofollow', target: '_blank' },
      space_after_headers: true,
      fenced_code_block: true
    }

    extensions = {
      superscript: true,
      disable_intended_code_block: true
    }

    renderer = Redcarpet::Render::HTML.new(options)
    markdown = Redcarpet::Markdown.new(renderer, extensions)

    markdown.render(text).html_safe
  end
end

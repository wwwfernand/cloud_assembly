# frozen_string_literal: true

class ArticleDecorator < Draper::Decorator
  delegate_all

  def published_at
    object.strftime('%m/%d %H:%M')
  end

  def published_html_body
    publish_section.html_body
  end

  def draft_html_body
    draft_section.html_body
  end
end

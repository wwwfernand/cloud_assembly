# frozen_string_literal: true

module ArticlesHelper
  def status_html(article)
    if article.revise?
      revised_tag(article)
    elsif article.future_publish?
      future_publish_tag(article)
    elsif article.published?
      published_tag(article)
    else
      draft_tag(article)
    end
  end

  private

  def revised_tag(article)
    content_tag :div do
      concat(link_to(show_article_path(article.id), target: '_blank', rel: 'noopener') do
        content_tag(:span, 'published')
      end)
      concat(link_to(draft_article_path(article.id), target: '_blank', rel: 'noopener') do
        content_tag(:span, 'revision')
      end)
    end
  end

  def future_publish_tag(article)
    link_to edit_member_article_path(article.id), target: '_blank', rel: 'noopener' do
      content_tag(:span, article.published_at)
    end
  end

  def published_tag(article)
    link_to show_article_path(article.id), target: '_blank', rel: 'noopener' do
      content_tag(:span, 'published')
    end
  end

  def draft_tag(article)
    link_to draft_article_path(article.id), target: '_blank', rel: 'noopener' do
      content_tag(:span, 'draft')
    end
  end
end

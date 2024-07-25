# frozen_string_literal: true

# create articles instances for index pages
module PublishedArticles
  extend ActiveSupport::Concern

  def authored_articles(user_id, exclude_article_ids: nil, limit: 6)
    articles = public_articles.where(user_id:)
    articles = articles.where.not(id: exclude_article_ids) if exclude_article_ids
    articles.popular.latest.limit(limit)
  end

  def tagged_articles(tag_names, exclude_article_ids: nil, limit: 6)
    articles = public_articles.tagged_with(names: tag_names, match: :any)
    articles = articles.where.not(id: exclude_article_ids) if exclude_article_ids
    articles.popular.latest.limit(limit)
  end

  def latest_articles(limit: 6)
    public_articles.latest.limit(limit)
  end

  private

  def public_articles
    Article.public_view.with_body
  end
end

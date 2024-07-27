# frozen_string_literal: true

# Controls display of main pages
class TopController < ApplicationController
  include PublishedArticles

  before_action :set_articles, only: :index

  def index
    target_article = @main_articles.first
    main_article_ids = @main_articles.ids
    @tag_related_articles = tagged_articles(target_article.tag_names, exclude_article_ids: main_article_ids)
    @author_related_articles = authored_articles(target_article.user_id,
                                                 exclude_article_ids: main_article_ids + @tag_related_articles.ids)
  end

  def about; end

  def privacy_policy; end

  def terms_of_use; end

  private

  def set_articles
    @main_articles = latest_articles.load
  end
end

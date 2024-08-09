# frozen_string_literal: true

# Controls tag-related articles display
class ArticleTagsController < ApplicationController
  include PublishedArticles

  before_action :set_tag_name
  before_action :set_articles_by_tag

  # GET /tags/tag_name
  def show
    @main_articles = ArticleDecorator.decorate_collection(@articles.first(6))
    @tag_related_articles = @articles.drop(6)
    @author_related_articles = ArticleDecorator.decorate_collection(
      authored_articles(@articles.first.user_id,
                        exclude_article_ids: @articles.ids)
    )
  end

  private

  def set_articles_by_tag
    @articles = tagged_articles([@tag_name], limit: 12).load
    redirect_to root_url if @articles.blank?
  end

  def set_tag_name
    @tag_name = params[:name]
  end
end

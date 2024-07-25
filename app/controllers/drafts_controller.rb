# frozen_string_literal: true

# Allow user to preview draft articles (sign-in not require)
class DraftsController < Member::BaseController
  before_action :set_article
  before_action :verify_article_status

  # GET /member/articles/1/draft
  def show; end

  private

  def set_article
    @article = Article.where(id: params[:id]).first
    redirect_to root_path unless @article
  end

  def verify_article_status
    return if @article.draft? || @article.revise?
    return if @article.publish_at.future?

    redirect_to show_article_path(@article)
  end
end

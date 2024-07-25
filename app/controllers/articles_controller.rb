# frozen_string_literal: true

# Controls published articles display
class ArticlesController < ApplicationController
  before_action :set_article

  # GET /articles/1
  def show; end

  private

  def set_article
    @article = Article.public_view.where(id: params[:id]).first
    redirect_to root_path unless @article
  end
end

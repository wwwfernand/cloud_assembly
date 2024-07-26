# frozen_string_literal: true

module Member
  # Controls article modification and publishing
  class ArticlesController < Member::BaseController
    include Pagy::Backend

    before_action :set_default_response_format, only: %i[create update]
    before_action :require_user, only: %i[index create edit update]
    before_action :set_article, only: %i[edit update]
    before_action :set_state, only: %i[create update]
    before_action :verify_publish_later, only: %i[update]

    rescue_from ArgumentError, with: :show_errors

    # GET /member/articles
    def index
      @pagy, @articles = pagy(policy_scope(Article).latest.decorate)
    end

    # GET /new
    def new; end

    # GET /member/articles/1/edit
    def edit; end

    # POST /new.json
    def create
      article = Article.new(create_params)

      respond_to do |format|
        if article.save(context: @state)
          format.json { render json: {}, status: :created }
        else
          format.json { render json: article.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /member/articles/1.json
    def update
      respond_to do |format|
        @article.assign_attributes(update_params)

        if @article.save(context: @state)
          format.json { render json: {}, status: :ok }
        else
          format.json { render json: @article.errors, status: :unprocessable_entity }
        end
      end
    end

    private

    def set_article
      @article = policy_scope(Article).find(params[:id])
      raise ArgumentError, 'article not found' unless @article
    end

    def create_params
      allowed_params = [:title, :tag_list, :image_link,
                        { draft_section_attributes: [:html_body] }]
      allowed_params << :publish_at if @state == Article::STATES[:publish_later]
      params.require(:article).permit(allowed_params).merge(user_id: current_user.id)
    end

    def update_params
      allowed_params = [{ draft_section_attributes: [:html_body] }]
      allowed_params.concat(%i[title tag_list image_link]) unless @article.public?
      allowed_params << :publish_at if @state == Article::STATES[:publish_later]
      params.require(:article).permit(allowed_params)
    end

    def set_state
      @state = params[:state]&.to_sym || Article::STATES[:draft]
    end

    def verify_publish_later
      return unless @state == Article::STATES[:publish_later]
      return if @article.publish_at.blank? || @article.publish_at.future?

      raise ArgumentError, 'can no longer be published at a later date'
    end
  end
end

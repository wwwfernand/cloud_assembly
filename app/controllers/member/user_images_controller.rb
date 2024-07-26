# frozen_string_literal: true

module Member
  # Controls images uploaded for articles
  class UserImagesController < Member::BaseController
    include Pagy::Backend

    before_action :set_default_response_format
    before_action :require_user

    rescue_from MiniMagick::Error, with: :render_invalid_image

    # GET /member/user_images.json
    def index
      pagy, user_images = pagy(policy_scope(UserImage).latest.decorate)
      respond_to do |format|
        format.json do
          render json: {
            pagy:,
            user_images: user_images.as_json(only: [], methods: %i[image_link thumbnail_link filename])
          }
        end
      end
    end

    # POST /member/user_images.json
    def create
      user_image = UserImage.new(user_image_params).decorate

      respond_to do |format|
        if user_image.save
          format.json do
            render json: user_image.as_json(only: [], methods: %i[image_link thumbnail_link filename]),
                   status: :created
          end
        else
          format.json { render json: user_image.errors, status: :unprocessable_entity }
        end
      end
    end

    private

    # Only allow a list of trusted parameters through.
    def user_image_params
      params.require(:user_image).permit(:image).merge(user_id: current_user.id)
    end

    def render_invalid_image
      show_errors(ArgumentError.new('invalid image file'))
    end
  end
end

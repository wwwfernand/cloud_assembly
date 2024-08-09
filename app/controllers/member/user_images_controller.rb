# frozen_string_literal: true

module Member
  # Controls images uploaded for articles
  class UserImagesController < Member::BaseController
    include Pagy::Backend

    before_action :set_default_response_format
    before_action :require_user

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
      user_images = UserImageDecorator.decorate_collection(multiple_upload_obj.run)

      respond_to do |format|
        format.json do
          render json: {
            images: ::JSON::UserImageRepresenter.for_collection.new(user_images).as_json,
            errors: multiple_upload_obj.errors
          }, status: :created
        end
      end
    end

    private

    # Only allow a list of trusted parameters through.
    def user_image_params
      params.require(:user_image).permit(image: [])
    end

    def multiple_upload_obj
      @multiple_upload_obj ||= Assembly::Images::MultipleUpload.new(user_image_params[:image], current_user.id)
    end
  end
end

# frozen_string_literal: true

module Member
  # Controls modification of users info
  class UsersController < Member::BaseController
    before_action :set_default_response_format, only: :update
    before_action :require_user

    # GET /member/profile
    def show; end

    # PATCH/PUT /member/profile
    def update
      # TODO: WIP
    end

    private

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:password)
    end
  end
end

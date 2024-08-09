# frozen_string_literal: true

# Controls user login and logout
class UserSessionsController < ApplicationController
  before_action :set_default_response_format
  before_action :require_no_user, only: :create

  skip_before_action :verify_authenticity_token, only: :destroy

  def create
    user_session = UserSession.new(user_session_params.to_h)
    respond_to do |format|
      if user_session.save
        format.json { render json: user_session.user, only: :username, status: :created }
      else
        # generic error msg for security
        format.json do
          render json: { base: [I18n.t('activerecord.errors.models.user.generic')] },
                 status: :unprocessable_entity
        end
      end
    end
  end

  def destroy
    current_user_session.destroy if current_user
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  private

  def user_session_params
    params.require(:user_session).permit(:email, :password).merge(remember_me: true)
  end
end

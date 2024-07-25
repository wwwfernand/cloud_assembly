# frozen_string_literal: true

module Member
  # Common methods for logged in user actions
  class BaseController < ApplicationController
    include Pundit::Authorization
    
    layout 'member'

    private

    def require_user
      return if current_user

      if request.format.json?
        render json: { You: ['need to sign in'] }, status: :forbidden
      else
        flash[:notice] = 'You need to sign in'
        redirect_to root_path
      end
    end
  end
end

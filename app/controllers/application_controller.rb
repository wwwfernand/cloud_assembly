# frozen_string_literal: true

# Common methods for controllers
class ApplicationController < ActionController::Base
  helper_method :current_user_session, :current_user

  private

  def current_user_session
    return @current_user_session if defined?(@current_user_session)

    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)

    @current_user = current_user_session&.user
  end

  def require_no_user
    return unless current_user

    if request.format.json?
      render json: { Already: ['a member'] }, status: :bad_request
    else
      flash[:notice] = 'Already a member'
      redirect_to request.request_uri
    end
  end

  def store_location
    session[:return_to] = request.request_uri
  end

  def redirect_back_or_root
    redirect_to(session[:return_to] || root_path)
    session[:return_to] = nil
  end

  def set_default_response_format
    request.format = :json unless params[:format]
  end

  def show_errors(exception)
    # TODO: notify error
    Rails.logger.error("#{self.class.name}.#{__method__} Exception: #{exception}")
    errors = JSON::Errors.from_exception(error: exception, object: nil)
    render json: errors,
           status: ActionDispatch::ExceptionWrapper.status_code_for_exception(exception.class.name)
  end
end

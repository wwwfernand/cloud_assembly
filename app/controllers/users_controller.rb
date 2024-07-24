# frozen_string_literal: true

# Controls user registration and user template
class UsersController < ApplicationController
  before_action :require_no_user, only: :create
  before_action :set_user, only: :show

  # GET /authors/username
  def show; end

  # POST /users.json
  def create
    user = User.new(user_params)

    respond_to do |format|
      if user.save
        format.json { render json: user, only: :username, status: :created }
      else
        format.json { render json: user.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :username, :password)
  end

  def set_user
    @user = User.where(username: params[:name]).first
    redirect_to root_path unless @user
  end
end

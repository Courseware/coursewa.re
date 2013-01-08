module Coursewareable
  # Password recovery controller
  class PasswordsController < ApplicationController

    # Do not check for abilities
    skip_load_and_authorize_resource
    # Do not ask authentication
    skip_before_filter :require_login
    # Redirect if authenticated
    before_filter :redirect_if_loggedin

    # Handles password recovery screen
    def new
    end

    # Handles password recovery submission
    def create
      @user = Coursewareable::User.find_by_email(params[:email])

      if @user
        @user.deliver_reset_password_instructions!
        flash[:secondary] = _('Please check your email for instructions.')
        redirect_to(login_path)
      else
        flash[:alert] = _('We could not find any accounts with this email.')
        redirect_to(new_password_path)
      end
    end

    # Handles password change screen
    def edit
      @user = Coursewareable::User.load_from_reset_password_token(params[:id])
      @token = params[:id]
      not_found if @user.nil?
    end

    # Handles password change
    def update
      @token = params[:token]
      @user = Coursewareable::User.load_from_reset_password_token(
        params[:token])
      return not_authenticated unless @user

      @user.password_confirmation = params[:password_confirmation]

      if @user.change_password!(params[:password])
        flash[:success] = _('Password successfully updated.')
        redirect_to(login_path)
      else
        flash[:alert] = _('Password was not updated. Please try again.')
        redirect_to(edit_password_path(@token))
      end
    end

  end
end

# Password recovery controller
class PasswordsController < ApplicationController

  # Do not check for abilities
  skip_authorization_check
  skip_before_filter :require_login

  # Handles password recovery screen
  def new
  end

  # Handles password recovery submission
  def create
    @user = User.find_by_email(params[:email])

    if @user
      @user.deliver_reset_password_instructions!
      flash[:secondary] = _('Please check your email for instructions.')
      redirect_to(root_path)
    else
      flash[:alert] = _('We could not find any accounts with this email.')
      redirect_to(new_password_path)
    end
  end

  # Handles password change screen
  def edit
    @user = User.load_from_reset_password_token(params[:id])
    @token = params[:id]
    not_authenticated unless @user
  end

  # Handles password change
  def update
    @token = params[:token]
    @user = User.load_from_reset_password_token(params[:token])
    not_authenticated unless @user

    @user.password_confirmation = params[:password_confirmation]

    if @user.change_password!(params[:password])
      flash[:success] = _('Password successfully updated.')
      redirect_to(root_path)
    else
      flash[:alert] = _('Password was not updated. Please try again.')
      redirect_to(edit_password_path)
    end
  end

end

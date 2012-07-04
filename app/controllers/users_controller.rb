# Courseware Users Controller class
class UsersController < ApplicationController

  skip_before_filter :require_login, :only => [:new, :create, :activate]

  # Handles user creation screen
  def new
    @user = User.new
  end

  # Handles user creation
  def create
    @user = User.new(params[:user])

      if @user.save
        redirect_to(@user, :notice => _('User was successfully created.'))
      else
        render :new
      end
  end

  # Handles user activation
  def activate
    if (@user = User.load_from_activation_token(params[:id]))
      @user.activate!
      redirect_to(login_path, :notice => _('User was successfully activated.'))
    else
      not_authenticated
    end
  end

  # TODO:
  # * Password reset (https://github.com/NoamB/sorcery/wiki/Reset-password)
  # * Profile edit... etc.

end

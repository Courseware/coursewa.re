# Courseware Users Controller class
class UsersController < ApplicationController

  # Handles user creation screen
  def new
    @user = User.new
  end

  # Handles user creation
  def create
    @user = User.new(params[:user])

      if @user.save
        redirect_to(@user, :notice => 'User was successfully created.')
      else
        render :new
      end
  end

  # Handles user activation
  def activate
    if (@user = User.load_from_activation_token(params[:id]))
      @user.activate!
      redirect_to(login_path, :notice => 'User was successfully activated.')
    else
      not_authenticated
    end
  end

end

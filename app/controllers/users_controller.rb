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
        redirect_to @user, notice: 'User was successfully created.'
      else
        render :new
      end
  end

end

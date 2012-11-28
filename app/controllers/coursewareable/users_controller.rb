module Coursewareable
  # Courseware Users Controller class
  class UsersController < ApplicationController

    # Do not check for abilities
    load_and_authorize_resource :class => Coursewareable::User
    skip_load_and_authorize_resource :except => [:create]
    # Do not ask authentication
    skip_before_filter :require_login, :except => [:me, :update]

    # Handles user creation screen
    def new
      redirect_to root_path if logged_in?
      @user = Coursewareable::User.new
    end

    # Handles user creation
    def create
      @user = Coursewareable::User.new(params[:user])

      if @user.save
        flash[:success] = _('Please check your email to finish registration.')
        redirect_to(root_url)
      else
        flash.now[:alert] = _(
          'We encountered errors. Please correct the highlighted fields.'
        )
        render :new
      end
    end

    # Handles user activation
    def activate
      if (@user = Coursewareable::User.load_from_activation_token(params[:id]))
        flash[:success] = _('Success! Your account was activated.')
        @user.activate!
        # Generate user's first activity
        @user.activities.create(:key => 'user.create')
        redirect_to(login_path)
      else
        not_authenticated
      end
    end

    # Handles user changes
    def update
      @user = current_user

      @user.update_attribute(:first_name, params[:user][:first_name])
      @user.update_attribute(:last_name, params[:user][:last_name])
      flash[:success] = _('Profile updated.')
      redirect_to(me_users_path)
    end

    # User profile control panel
    def me
      @user = current_user
    end

  end
end

module Coursewareable
  # Courseware Users Controller class
  class UsersController < ApplicationController

    # Do not check for abilities
    load_and_authorize_resource :class => Coursewareable::User
    skip_load_and_authorize_resource :except => [:create, :suggest]
    # Do not ask authentication
    skip_before_filter :require_login, :only => [:new, :activate, :create]

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
        redirect_to(login_path)
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
        activity_key = Coursewareable::User.name.parameterize('_')
        @user.activities_as_owner.create(
          :key => "#{activity_key}.create",
          :parameters => { :user_name => @user.name }
        )
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
      @user.update_attribute(:description, params[:user][:description])
      flash[:success] = _('Profile updated.')
      redirect_to(me_users_path)
    end

    # User profile control panel
    def me
      @user = current_user
    end

    # User invitation screen
    def invite
    end

    # User account page
    def my_account
    end

    # Handles invitations form
    def send_invitation
      if params[:email].blank? or params[:message].blank?
        flash[:alert] = _('Please fill in all the fields')
        redirect_to(invite_users_path) and return
      end

      params[:registration_link] = signup_url(:subdomain => false)
      ::GenericMailer.delay.invitation_email(current_user, params)

      flash[:success] = _('Invitation sent')
      redirect_to(invite_users_path)
    end

    # Manage email settings
    def notifications
      # fill email field for current_user's classrooms.
      current_user.memberships.all.each do |m|
        if m.email_announcement.empty?
          m.email_announcement = {
            :grade => true, :announce => true,
            :collaboration => true, :generic => true,
            :membership => true
          }
          m.save if m.valid?
        end
      end

      @memberships = current_user.memberships.all
    end

    # Update email settings
    def update_notifications
      # Search for specific membership
      memberships = current_user.memberships.all
      memberships.each do |m|
        m.email_announcement = params[:memberships][m.id.to_s.to_sym][:email_announcement]
        if m.valid?
          m.save
        end
      end
      flash[:success] = _('Notifications settings updated successfully')
      redirect_to(notifications_users_path)
   end

  end
end

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

      current_user.sent_invitations.create(:email => params[:email])
      params[:registration_link] = signup_url(:subdomain => false)
      ::GenericMailer.delay.invitation_email(current_user, params)

      flash[:success] = _('Invitation sent')
      redirect_to(invite_users_path)
    end

    # Manage email settings
    def notifications
    end

    # Updates email settings
    def update_notifications
      # Nested attributes are not working for sorcery, handle update manually
      params[:user][:associations_attributes].each do |notification|
        attrs = notification.last
        next if attrs.blank?
        association = current_user.associations.where(:id => attrs[:id]).first
        association.update_attributes(attrs.except(:id)) unless association.nil?
      end
      flash[:success] = _('Your notification settings were updated')
      redirect_to(notifications_users_path)
    end

    def request_deletion
      if request.post?
        if params[:message].blank?
          flash[:alert] = _('Please fill the field!')
          redirect_to(request_deletion_users_path) and return
        end

        ::GenericMailer.delay.support_email({
          :name => current_user.name,
          :email => current_user.email,
          :remote_ip => request.remote_ip,
          :message => params[:message]
        })

        flash[:success] = _('Your request was sent.')
        redirect_to(dashboard_home_path)
      end
    end

  end
end

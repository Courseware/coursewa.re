module Coursewareable
  # Courseware application controller
  class ApplicationController < ActionController::Base

    # CSRF protection
    protect_from_forgery

    # Abilities checking
    load_and_authorize_resource

    # Setup locale
    before_filter :set_gettext_locale

    # Ask users to authenticate
    before_filter :require_login

    # Handle errors
    rescue_from CanCan::AccessDenied, :with => :unauthorized
    rescue_from ActiveRecord::RecordNotFound, :with => :not_found

    private
    # Sorcery method overwritten to customize error message
    def not_authenticated
      redirect_to(login_url, :alert => _('Please authenticate first.'))
    end

    # Unauthorized error handler
    def unauthorized
      redirect_to(login_url, :alert => _('Access to this page is restricted.'))
    end

    # Not found handler
    def not_found
      redirect_to('/404')
    end
  end
end

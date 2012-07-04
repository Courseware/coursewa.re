# Courseware application controller
class ApplicationController < ActionController::Base
  protect_from_forgery

  # Setup locale
  before_filter :set_gettext_locale

  # Ask users to authenticate
  before_filter :require_login

  private
    # Sorcery method overwritten to customize error message
    def not_authenticated
      redirect_to login_url, :alert => _('First log in to view this page.')
    end
end

# Courseware application controller
class ApplicationController < ActionController::Base
  # CSRF protection
  protect_from_forgery

  # Setup locale
  before_filter :set_gettext_locale
end

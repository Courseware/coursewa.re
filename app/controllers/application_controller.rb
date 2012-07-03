# Courseware application controller
class ApplicationController < ActionController::Base
  protect_from_forgery

  private
    # Sorcery method overwritten to customize error message
    def not_authenticated
      redirect_to login_url, alert: 'First log in to view this page.'
    end
end

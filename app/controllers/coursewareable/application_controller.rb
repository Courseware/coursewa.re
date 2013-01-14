# The [Coursewareable] namespace
module Coursewareable
  # Courseware application controller
  class ApplicationController < ::ApplicationController
    # Ask users to authenticate
    before_filter :require_login

    # Handle errors
    rescue_from CanCan::AccessDenied, :with => :unauthorized
    rescue_from ActiveRecord::RecordNotFound, :with => :not_found

    private

    # Sorcery method overwritten to customize error message
    def not_authenticated
      args = {:subdomain => request.subdomain} unless request.subdomain.blank?
      redirect_to(login_url(args), :alert => _('Please authenticate first.'))
    end

    # Unauthorized error handler
    def unauthorized
      args = {:subdomain => request.subdomain} unless request.subdomain.blank?
      redirect_to(
        login_url(args), :alert => _('Access to this page is restricted.') )
    end

    # Not found handler
    def not_found
      redirect_to('/404')
    end

    # Redirect if authenticated
    def redirect_if_loggedin
      if logged_in?
        redirect_to(root_path, :alert => _('You logged in once already.'))
      end
    end
  end
end

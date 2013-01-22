module Coursewareable
  # Courseware Sessions Controller
  class SessionsController < ApplicationController

    # Do not check for abilities
    skip_load_and_authorize_resource
    # Do not ask authentication
    skip_before_filter :require_login, :except => [:destroy]
    # Redirect if logged in
    before_filter :redirect_if_loggedin, :except => [:destroy]

    # New session screen handler
    def new
    end

    # New session handler
    def create
      user = login(params[:email], params[:password], params[:remember_me])
      subdomain = request.subdomain unless request.subdomain.blank? || false
      if user
        flash[:notice] = _('Welcome back %{name}!' % {:name => user.name})
        redirect_back_or_to(root_url(:subdomain => subdomain))
      else
        flash.now.alert = _('Email or password was invalid.')
        render :new
      end
    end

    # Destroys session, aka logout
    def destroy
      logout
      subdomain = request.subdomain unless request.subdomain.blank? || false
      redirect_to root_url(:subdomain => subdomain), :notice => _('Logged out!')
    end
  end
end

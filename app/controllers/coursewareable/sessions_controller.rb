module Coursewareable
  # Courseware Sessions Controller
  class SessionsController < ApplicationController

    # Do not check for abilities
    skip_load_and_authorize_resource
    # Do not ask authentication
    skip_before_filter :require_login, :except => [:destroy]

    # New session screen handler
    def new
    end

    # New session handler
    def create
      user = login(params[:email], params[:password], params[:remember_me])
      if user
        flash[:notice] = _(
          'Welcome back %{name}!' % {:name => user.name}
        )
        redirect_back_or_to(home_index_path)
      else
        flash.now.alert = _('Email or password was invalid.')
        render :new
      end
    end

    # Destroys session, aka logout
    def destroy
      logout
      redirect_to root_url, :notice => _('Logged out!')
    end
  end
end

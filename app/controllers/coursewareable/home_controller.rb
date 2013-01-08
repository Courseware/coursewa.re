module Coursewareable
  # Courseware Main Page Controller class
  class HomeController < ApplicationController

    # Do not check for abilities, but load the class properly
    load_and_authorize_resource :class => Coursewareable::Classroom
    skip_authorize_resource
    # Do not require login for homepage
    skip_before_filter :require_login, :only => [:index]

    # Main page handler
    def index
      redirect_to(dashboard_home_index_path) and return if logged_in?
      render(:layout => 'application')
    end

    # User Dashboard handler
    def dashboard
      redirect_to home_index_path unless logged_in?
      @timeline = current_user.activities_as_owner.reverse
    end

  end
end

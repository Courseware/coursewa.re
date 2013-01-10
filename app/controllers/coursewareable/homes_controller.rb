module Coursewareable
  # Courseware Main Page Controller class
  class HomesController < ApplicationController

    # Do not check for abilities, but load the class properly
    load_and_authorize_resource :class => Coursewareable::Classroom
    skip_authorize_resource
    # Do not require login for homepage
    skip_before_filter :require_login, :only => [:index, :about, :contact]

    # Main page handler
    def index
      if logged_in?
        redirect_to(dashboard_home_path)
      else
        render(:layout => 'landing')
      end
    end

    # User Dashboard handler
    def dashboard
      redirect_to root_path unless logged_in?
      @timeline = current_user.activities_as_owner.reverse
    end

    # About page
    def about
    end

    # Contact/Feedback page
    def contact
    end

  end
end

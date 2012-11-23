module Coursewareable
  # Courseware Main Page Controller class
  class HomeController < ApplicationController

    # Do not check for abilities
    skip_load_and_authorize_resource

    # Main page handler
    def index
      redirect_to dashboard_home_index_path if logged_in?
    end

    # User Dashboard handler
    def dashboard
      redirect_to home_index_path unless logged_in?
      @timeline = current_user.activities
    end

  end
end

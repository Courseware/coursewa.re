# Courseware Main Page Controller class
class HomeController < ApplicationController

  # Do not check for abilities
  skip_load_and_authorize_resource

  # Main page handler
  def index
  end

end

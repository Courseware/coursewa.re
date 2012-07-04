# Courseware Main Page Controller class
class HomeController < ApplicationController

  before_filter :require_login, {only: :index}

  # Main page handler
  def index
  end

end

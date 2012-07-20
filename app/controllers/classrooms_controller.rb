# Courseware classroom controller
class ClassroomsController < ApplicationController

  skip_before_filter :require_login, :only => [:show]

  def show
    @classroom = Classroom.find_by_slug!(request.subdomain)
  end
end

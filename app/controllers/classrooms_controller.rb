# Courseware classroom controller
class ClassroomsController < ApplicationController

  def show
    @classroom = Classroom.find_by_slug!(request.subdomain)
  end
end

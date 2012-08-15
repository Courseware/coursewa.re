# Courseware classroom controller
class ClassroomsController < ApplicationController

  # Mapped to [Classroom] subdomain
  def show
    @classroom = Classroom.find_by_slug!(request.subdomain)
  end
end

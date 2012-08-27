# Courseware classroom controller
class ClassroomsController < ApplicationController

  # Classroom dashboard
  # Mapped to [Classroom] subdomain
  def dashboard
    @classroom = Classroom.find_by_slug!(request.subdomain)
    @timeline = @classroom.activities
  end

  # Classroom creation page
  def new
  end

  # Classroom creation hadler
  def create
    if cr = current_user.created_classrooms.create(params[:classroom])
      redirect_to(root_url(:subdomain => cr.slug))
    else
      redirect_to(start_classroom_path)
    end
  end
end

module Coursewareable
  # Classroom controller
  class ClassroomsController < ApplicationController
    # Abilities checking
    load_and_authorize_resource :class => Coursewareable::Classroom

    # Classroom dashboard
    # Mapped to [Classroom] subdomain
    def dashboard
      @classroom = Coursewareable::Classroom.find_by_slug!(request.subdomain)
      @timeline = @classroom.all_activities
    end

    # Classroom creation page
    def new
      @new_classroom = current_user.created_classrooms.build
    end

    # Classroom creation hadler
    def create
      classroom = current_user.created_classrooms.build(params[:classroom])
      if classroom.save
        redirect_to(root_url(:subdomain => classroom.slug))
      else
        redirect_to(start_classroom_path)
      end
    end
  end
end

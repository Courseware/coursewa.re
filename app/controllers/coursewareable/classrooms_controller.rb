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

    # Customization page
    def edit
      @classroom = Coursewareable::Classroom.find_by_slug!(request.subdomain)
    end

    # Handles submitted changes
    def update
      classroom = Coursewareable::Classroom.find_by_slug!(request.subdomain)
      classroom.update_attributes(params[:classroom])

      if classroom.save
        flash[:success] = _('Classroom updated')
      else
        flash[:alert] = _('Classroom was not updated. Please try again.')
      end

      # TODO: Fix redirect flashes
      redirect_to edit_classroom_url(:subdomain => classroom.slug)
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

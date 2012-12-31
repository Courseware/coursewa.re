module Coursewareable
  # Classroom controller
  class ClassroomsController < ApplicationController
    # Abilities checking
    load_and_authorize_resource :class => Coursewareable::Classroom
    skip_authorize_resource

    before_filter :load_classroom, :only => [:dashboard, :edit, :update]

    # Classroom dashboard
    # Mapped to [Classroom] subdomain
    def dashboard
      authorize!(:dashboard, @classroom)
      @timeline = @classroom.all_activities
    end

    # Classroom creation page
    def new
      @new_classroom = current_user.created_classrooms.build
      authorize!(:create, @new_classroom)
    end

    # Customization page
    def edit
      authorize!(:update, @classroom)
    end

    # Handles submitted changes
    def update
      authorize!(:update, @classroom)
      @classroom.update_attributes(params[:classroom])

      new_members = params[:members].to_s.split(',').uniq.compact
      unless new_members.empty?
        @classroom.member_ids += new_members.map(&:to_i)
      end

      new_collabs = params[:collaborators].to_s.split(',').uniq.compact
      unless new_collabs.empty?
        @classroom.collaborator_ids += new_collabs.map(&:to_i)
      end

      redirect_to edit_classroom_url(:subdomain => @classroom.reload.slug)
    end

    # Classroom creation hadler
    def create
      classroom = current_user.created_classrooms.build(params[:classroom])
      authorize!(:create, classroom)

      if classroom.save
        redirect_to(root_url(:subdomain => classroom.slug))
      else
        redirect_to(start_classroom_path)
      end
    end

    protected

    # Loads current classroom
    def load_classroom
      @classroom = Coursewareable::Classroom.find_by_slug!(request.subdomain)
    end

  end
end

module Coursewareable
  # Assignments controller
  class AssignmentsController < ApplicationController

    # Abilities checking for our nested resource
    load_and_authorize_resource :class => Coursewareable::Assignment
    skip_authorize_resource :only => [:create, :new]

    before_filter :load_classroom_lecture

    # Handles creation screen
    def new
      @assignment = @lecture.assignments.build
      @assignment.classroom = @classroom
      @assignment.user = current_user

      authorize!(:create, @assignment)
    end

    # Handles creation
    def create
      @assignment = @lecture.assignments.build(
        params[:assignment].except(:has_quiz))

      @assignment.classroom = @classroom
      @assignment.user = current_user

      authorize!(:create, @assignment)

      unless params[:has_quiz]
        @assignment.quiz = nil
      end

      if @assignment.save
        flash[:success] = _('Assignment was created.')
        redirect_to lecture_assignment_url(
          @lecture, @assignment, :subdomain => @classroom.slug)
      else
        flash[:alert] = _('There was an error, please try again.')
        render :new
      end
    end

    # Handles assignment screen
    def show
      @assignment = @lecture.assignments.find(params[:id])
    end

    # Handles editing screen
    def edit
      @assignment = @lecture.assignments.find(params[:id])
    end

    # Handles update
    def update
      @assignment = @lecture.assignments.find(params[:id])
      @assignment.update_attributes(params[:assignment])

      unless params[:has_quiz]
        @assignment.quiz = nil
      end

      if @assignment.save
        flash[:success] = _('Assignment was updated.')
        redirect_to lecture_assignment_url(
          @lecture, @assignment, :subdomain => @classroom.slug)
      else
        flash[:alert] = _('There was an error, please try again.')
        render :edit
      end

    end

    # Handles removal
    def destroy
      assignment = @lecture.assignments.find(params[:id])

      if assignment.destroy
        flash[:success] = _('Assignment removed.')
      end

      redirect_to lecture_path(@lecture)
    end

    protected

    # Loads current classroom and lecture
    def load_classroom_lecture
      @classroom = Coursewareable::Classroom.find_by_slug!(request.subdomain)
      @lecture = @classroom.lectures.find_by_slug(params[:lecture_id])
    end
  end
end

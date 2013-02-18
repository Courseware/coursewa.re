module Coursewareable
  # [Assignment] responses controller
  class ResponsesController < ApplicationController

    # Abilities checking for our nested resource
    load_and_authorize_resource :class => Coursewareable::Response
    skip_authorize_resource :only => [:create, :new]

    before_filter :load_classroom_assignment

    # Creation screen
    def new
      @response = @assignment.responses.build
      @response.classroom = @classroom
      @response.user = current_user
      @lecture = @assignment.lecture

      authorize!(:create, @response)
    end

    # Handles response creation
    def create
      @lecture = @assignment.lecture
      @response = @assignment.responses.build(params[:response])
      @response.classroom = @classroom
      @response.user = current_user

      @response.answers = nil if @assignment.quiz.blank?

      authorize!(:create, @response)

      if @response.save
        flash[:success] = _('Your response was added.')
        redirect_to lecture_assignment_response_path(
          @lecture, @assignment, @response)
      else
        flash[:alert] = _('There was an error, please try again.')
        render :new
      end
    end

    # Handles response screen
    def show
      @lecture = @assignment.lecture
      @assignment.responses.find(params[:id])
    end

    # Handles deletion
    def destroy
      resp = @assignment.responses.find(params[:id])

      if resp.destroy
        flash[:success] = _('Response removed.')
      end

      redirect_to lecture_assignment_path(params[:lecture_id], @assignment)
    end

    protected

    # Loads current classroom and assignment
    def load_classroom_assignment
      @classroom = Coursewareable::Classroom.find_by_slug!(request.subdomain)
      @assignment = @classroom.assignments.find_by_slug!(params[:assignment_id])
    end
  end
end

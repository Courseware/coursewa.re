module Coursewareable
  # [Assignment] responses controller
  class ResponsesController < ApplicationController

    # Abilities checking for our nested resource
    load_and_authorize_resource :class => Coursewareable::Response
    skip_authorize_resource :only => [:create, :new]

    before_filter :load_classroom_assignment

    # Creation screen
    def new
    end

    # Handles response creation
    def create
    end

    # Handles response screen
    def show
    end

    # Handles deletion
    def destroy
    end

    protected

    # Loads current classroom and lecture
    def load_classroom_assignment
      @classroom = Coursewareable::Classroom.find_by_slug!(request.subdomain)
      @assignment = @classroom.assignments.find_by_slug(params[:assignment_id])
    end
  end
end

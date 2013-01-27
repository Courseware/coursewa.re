module Coursewareable
  # Classroom syllabus controller
  class SyllabusesController < ApplicationController

    # Abilities checking for our nested resource
    load_and_authorize_resource :class => Coursewareable::Syllabus
    skip_authorize_resource

    before_filter :load_classroom_syllabus

    # Syllabus page handler
    def show
      authorize!(:read, @syllabus)
      @lectures = @classroom.lectures
    end

    # Edit page handler
    def edit
      authorize!(:edit, @syllabus)
    end

    # Creates syllabus handler
    def create
      @syllabus.attributes = params[:syllabus]
      @syllabus.user = current_user

      authorize!(:create, @syllabus)

      if @syllabus.new_record? and @syllabus.save
        flash[:success] = _('Classroom syllabus updated.')
      else
        flash[:alert] = _('There was an error, please try again.')
      end

      render :show
    end

    # Updates syllabus handler
    def update
      authorize!(:update, @syllabus)

      redirect_to(edit_syllabus_path) and return if @syllabus.new_record?

      if @syllabus.update_attributes(params[:syllabus])
        # Change last user who edited syllabus to current user
        @syllabus.update_attribute(:user, current_user)

        flash[:success] = _('Classroom syllabus updated.')
      else
        flash[:alert] = _('There was an error, please try again.')
      end

      render :show
    end

    protected

    # Loads current classroom and its syllabus
    def load_classroom_syllabus
      @classroom = Coursewareable::Classroom.find_by_slug!(request.subdomain)
      @syllabus = @classroom.syllabus || @classroom.build_syllabus
    end

  end
end

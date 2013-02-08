module Coursewareable
  # Lectures controller
  class LecturesController < ApplicationController

    # Abilities checking for our nested resource
    load_and_authorize_resource :class => Coursewareable::Lecture
    skip_authorize_resource :only => [:create, :new]

    before_filter :load_classroom_syllabus

    # Creation screen
    def new
      @lectures = @classroom.lectures.compact
      @lecture = @classroom.lectures.build(params[:lecture])
      @lecture.user = current_user

      authorize!(:create, @lecture)
    end

    # Editing screen
    def edit
      @lecture = @classroom.lectures.find(params[:id])
      @lectures = @classroom.lectures
    end

    # Lecture screen
    def show
      @lecture = @classroom.lectures.find(params[:id])
    end

    # Handles lecture creation
    def create
      @lecture = @classroom.lectures.build(params[:lecture])
      @lecture.user = current_user

      authorize!(params[:action].to_sym, @lecture)

      if @lecture.new_record? and @lecture.save
        flash[:success] = _('Lecture was created.')
        redirect_to lecture_url(@lecture, :subdomain => @classroom.slug)
      else
        flash[:alert] = _('There was an error, please try again.')
        render :new
      end
    end

    # Handles lecture update
    def update
      @lecture = @classroom.lectures.find(params[:id])
      @lecture.update_attributes(params[:lecture])

      if @lecture.save
        flash[:success] = _('Lecture was update')
      else
        flash[:alert] = _('There was an error, please try again.')
      end

      redirect_to lecture_url(@lecture, :subdomain => @classroom.slug)
    end

    # Handles lecture deletion
    def destroy
      lecture = @classroom.lectures.find(params[:id])

      if lecture and lecture.destroy
        flash[:success] = _('Lecture removed.')
      end

      redirect_to :syllabus
    end

    protected

    # Loads current classroom and its syllabus
    def load_classroom_syllabus
      @classroom = Coursewareable::Classroom.find_by_slug!(request.subdomain)
      @syllabus = @classroom.syllabus
    end
  end
end

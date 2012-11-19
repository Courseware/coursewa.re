# Classroom syllabus controller
class SyllabusesController < ApplicationController

  # Abilities checking for our nested resource
  skip_authorize_resource :only => :create

  before_filter :load_classroom_syllabus

  # Syllabus page handler
  def show
  end

  # Edit page handler
  def edit
    @syllabus ||= @classroom.build_syllabus
  end

  # Creates syllabus handler
  def create
    @syllabus ||= @classroom.build_syllabus(params[:syllabus])
    @syllabus.user = current_user

    authorize!(params[:action].to_sym, @syllabus)

    if @syllabus.new_record? and @syllabus.save
      flash[:success] = _('Classroom syllabus updated.')
    else
      flash[:alert] = _('There was an error, please try again.')
    end

    render :show
  end

  # Updates syllabus handler
  def update
    if !@syllabus.nil? and @syllabus.update_attributes(params[:syllabus])
      flash[:success] = _('Classroom syllabus updated.')
    else
      flash[:alert] = _('There was an error, please try again.')
    end

    render :show
  end

  protected

  # Loads current classroom and its syllabus
  def load_classroom_syllabus
    @classroom = Classroom.find_by_slug!(request.subdomain)
    @syllabus = @classroom.syllabus
  end

end

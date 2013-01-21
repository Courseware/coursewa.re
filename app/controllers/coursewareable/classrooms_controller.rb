module Coursewareable
  # Classroom controller
  class ClassroomsController < ApplicationController
    # Abilities checking
    load_and_authorize_resource :class => Coursewareable::Classroom
    skip_authorize_resource

    before_filter :load_classroom, :except => [:new, :create]
    before_filter :change_header_image, :only => [:update]

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
      @classroom.update_attributes(
        params[:classroom].except(:color_scheme, :header_image, :color))

      new_member = Coursewareable::User.find_by_email(params[:member_email])
      @classroom.member_ids += [new_member.id] unless new_member.nil?

      new_collab = Coursewareable::User.find_by_email(
        params[:collaborator_email])
      @classroom.collaborator_ids += [new_collab.id] unless new_collab.nil?

      redirect_to edit_classroom_url(:subdomain => @classroom.reload.slug)
    end

    # Classroom creation hadler
    def create
      classroom = current_user.created_classrooms.build(params[:classroom])
      authorize!(:create, classroom)

      if classroom.save
        redirect_to(root_url(:subdomain => classroom.slug))
      else
        flash[:alert] = _('Please fill in all the fields.')
        redirect_to(start_classroom_path)
      end
    end

    def announce
      authorize!(:contribute, @classroom)

      activity_key = 'announcement.create'
      current_user.activities_as_owner.create(
        :key => activity_key, :recipient => @classroom, :parameters => {
          :content => Sanitize.clean(params[:announcement])
        })
      flash[:success] = _('Announcement was posted')
      redirect_to(dashboard_classroom_path)
    end

    protected

    # Loads current classroom
    def load_classroom
      @classroom = Coursewareable::Classroom.find_by_slug!(request.subdomain)
    end

    # Handle uploaded header image
    def change_header_image
      authorize!(:update, @classroom)

      upload = params[:classroom][:header_image]
      return if upload.blank?

      size = Paperclip::Geometry.from_file(upload)
      ok_size = Courseware.config.header_image_size

      return if size.width < ok_size[:width] or size.height != ok_size[:height]

      himg = @classroom.images.build
      himg.attachment = params[:classroom][:header_image]
      himg.description = _('Header image, %s') % DateTime.new.to_s(:pretty)
      himg.assetable = @classroom
      himg.user = current_user

      @classroom.update_attribute(:header_image, himg.id) if himg.save
    end

  end
end

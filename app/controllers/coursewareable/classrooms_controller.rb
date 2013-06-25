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
      timeline = @classroom.all_activities
      @timeline = Kaminari.paginate_array(timeline).page(params[:page])
      render(:partial => 'shared/timeline') if request.xhr?
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

      # Remove any built temporary image
      @classroom.images.reload

      attrs = params[:classroom].except(:color_scheme, :header_image, :color)
      @classroom.update_attributes(attrs)

      redirect_to dashboard_classroom_url(:subdomain => @classroom.reload.slug)
    end

    # Handles classroom creation
    def create
      classroom = current_user.created_classrooms.build(params[:classroom])
      authorize!(:create, classroom)

      if classroom.save
        redirect_to(root_url(:subdomain => classroom.slug))
      else
        flash[:alert] =
          _('Try another classroom title or fill in all the fields.')
        redirect_to(start_classroom_path)
      end
    end

    # Handles announcement creation
    def announce
      authorize!(:contribute, @classroom)

      activity_key = 'announcement.create'
      announcement = current_user.activities_as_owner.create(
        :key => activity_key, :recipient => @classroom, :parameters => {
          :content => Sanitize.clean(params[:announcement]),
          :user_name => current_user.name
        })
      ::AnnouncementMailer.delay.new_announcement_email(announcement)
      flash[:success] = _('Announcement was posted')
      redirect_to(dashboard_classroom_path)
    end

    # Handles staff page
    def staff
      authorize!(:dashboard, @classroom)
    end

    # Handles time-series stats page
    def stats
      authorize!(:dashboard, @classroom)

      respond_to do |format|
        format.html
        format.json {
          render :json => @classroom.all_activities.select([:created_at, :key])
        }
      end
    end

    protected

    # Loads current classroom
    def load_classroom
      @classroom = Coursewareable::Classroom.find_by_slug!(request.subdomain)
    end

    # Handle uploaded header image
    def change_header_image
      authorize!(:update, @classroom)

      himg = @classroom.images.build
      himg.attachment = params[:classroom][:header_image]
      himg.description = _('New header image')
      himg.assetable = @classroom
      himg.user = current_user
      return unless himg.valid?

      ok_size = Courseware.config.header_image_size
      # Wrap this in a rescue block to avoid all kind of weird exceptions
      begin
        size = Paperclip::Geometry.from_file(params[:classroom][:header_image])
      rescue
        return
      end

      return if size.width < ok_size[:width] or size.height != ok_size[:height]

      if can?(:create, himg) and himg.save
        @classroom.update_attribute(:header_image, himg.id)
      end
    end

  end
end

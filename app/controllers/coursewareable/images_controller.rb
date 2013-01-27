module Coursewareable
  # Generic images uploader
  class ImagesController < ApplicationController

    # Abilities checking for our nested resource
    load_and_authorize_resource :class => Coursewareable::Image
    skip_authorize_resource :only => [:create, :index]

    before_filter :load_classroom

    # Images list handler (JSON)
    def index
      # Handle authorization based on a pre-built object
      authorize!(:index, @classroom.images.build)

      respond_to do |format|
        # format.html
        format.json {
          render :json => @classroom.images.reload.collect { |img| {
            :folder => img.assetable.title,
            :image => img.url(:large),
            :thumb => img.url(:small),
            :title => img.description
          } }
        }
      end
    end

    # Image upload handler
    def create
      img = @classroom.images.build

      if !params[:file].nil?
        img.attachment = params[:file]
        img.description = params[:file].original_filename
        img.assetable_type = params[:assetable_type]
        img.assetable_id = params[:assetable_id]
        img.user = current_user
      end

      authorize!(:create, img)

      if img.save
        render :text => {
          :filelink => img.url(:large), :filename => img.description }.to_json
      else
        error = _('Upload failed. Try saving the page first and try again.')
        if(img.attachment_file_size > current_user.plan.left_space)
          error = _('File storage limits reached. Please upgrade your plan.')
        end

        render(:status => :bad_request, :json => { :error => error } )
      end
    end

    # Handles deletion
    def destroy
      img = @classroom.images.find(params[:id])

      if img and img.destroy
        flash[:success] = _('Image was deleted.')
      end

      redirect_to :images
    end

    protected

    # Loads current classroom
    def load_classroom
      @classroom = Coursewareable::Classroom.find_by_slug!(request.subdomain)
    end
  end
end

module Coursewareable
  # Generic images uploader
  class ImagesController < ApplicationController

    # Abilities checking for our nested resource
    load_and_authorize_resource :class => Coursewareable::Image
    skip_authorize_resource :only => :create

    before_filter :load_classroom

    # Images list handler (JSON)
    def index

      respond_to do |format|
        # format.html
        format.json {
          render :json => @classroom.images.collect { |img| {
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

      authorize!(params[:action].to_sym, img)

      if img.save
        render :text => {
          :filelink => img.url(:large), :filename => img.description }.to_json
      else
        render(:status => :bad_request, :json => {
          :error => _('Upload failed. Please save the page first and try again.')
        } )
      end
    end

    # Handles deletion
    def destroy
      img = Coursewareable::Image.find(params[:id])

      if img and img.destroy
        flash[:success] = _('Image was deleted.')
      end

      redirect_to :index
    end

    protected

    # Loads current classroom
    def load_classroom
      @classroom = Coursewareable::Classroom.find_by_slug!(request.subdomain)
    end
  end
end

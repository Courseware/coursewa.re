module Coursewareable
  # Generic uploads handler
  class UploadsController < ApplicationController

    # Abilities checking for our nested resource
    load_and_authorize_resource :class => Coursewareable::Upload
    skip_authorize_resource :only => :create

    before_filter :load_classroom

    # Uploads handler
    def create
      upload = @classroom.uploads.build

      if !params[:file].nil?
        upload.attachment = params[:file]
        upload.description = params[:file].original_filename
        upload.assetable_type = params[:assetable_type]
        upload.assetable_id = params[:assetable_id]
        upload.user = current_user
      end

      authorize!(:create, upload)

      if upload.save
        render :text => {
          :filelink => upload.url, :filename => upload.description
        }.to_json
      else
        error = _('Upload failed. Try saving the page first and try again.')
        if(upload.attachment_file_size > current_user.plan.left_space)
          error = _('File storage limits reached. Please upgrade your plan.')
        end

        render(:status => :bad_request, :json => { :error => error } )
      end
    end

    # Handles deletion
    def destroy
      upload = @classroom.uploads.find(params[:id])

      if upload and upload.destroy
        flash[:success] = _('File was deleted.')
      end

      redirect_to dashboard_classroom_path
    end

    protected

    # Loads current classroom
    def load_classroom
      @classroom = Coursewareable::Classroom.find_by_slug!(request.subdomain)
    end
  end
end

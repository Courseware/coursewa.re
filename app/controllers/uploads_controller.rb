# Generic uploads handler
class UploadsController < ApplicationController

  # Abilities checking for our nested resource
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

    authorize!(params[:action].to_sym, upload)

    if upload.save
      render :text => {
        :filelink => upload.url, :filename => upload.description
      }.to_json
    else
      render(:status => :bad_request, :json => {
        :error => _('Upload failed. Please save the page first and try again.')
      } )
    end
  end

  # Handles deletion
  def destroy
    upload = Upload.find(params[:id])

    if upload and upload.destroy
      flash[:success] = _('File was deleted.')
    end

    redirect_to :index
  end

  protected

  # Loads current classroom
  def load_classroom
    @classroom = Classroom.find_by_slug!(request.subdomain)
  end
end

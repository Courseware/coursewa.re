module Coursewareable
  # Generic uploads handler
  class FilesController < ApplicationController

    # Abilities checking for our nested resource
    load_and_authorize_resource :class => Coursewareable::Asset
    skip_authorize_resource

    before_filter :load_classroom

    # All files listing page
    def index
      authorize!(:dashboard, @classroom)

      if can?(:contribute, @classroom)
        assets = @classroom.assets.reverse
      else
        assets = @classroom.assets.where(:user_id => current_user.id).reverse
      end

      @assets = Kaminari.paginate_array(assets).page(params[:page])
      render(:partial => 'listing') if request.xhr?
    end

    # Handles deletion of a file
    def destroy
      file = @classroom.assets.find(params[:id])
      authorize!(:destroy, file)

      if file and file.destroy
        flash.now[:success] = _('File was deleted')
        flash.keep
      end

      redirect_to files_path
    end

    protected

    # Loads current classroom
    def load_classroom
      @classroom = Coursewareable::Classroom.find_by_slug!(request.subdomain)
    end
  end
end

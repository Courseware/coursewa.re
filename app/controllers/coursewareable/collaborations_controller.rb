module Coursewareable
  # Handles Classroom collaborations
  class CollaborationsController < ApplicationController
    # Abilities checking
    load_and_authorize_resource :class => Coursewareable::Collaboration

    before_filter :load_classroom, :only => [:destroy]

    # Removes a collaborator
    def destroy
      if @classroom.collaborations.destroy(params[:id])
        flash[:success] = _('Collaborator removed successfully.')
      else
        flash[:alert] = _('There was an error. Please try again.')
      end
      redirect_to edit_classroom_path
    end

    protected

    # Loads current classroom
    def load_classroom
      @classroom = Coursewareable::Classroom.find_by_slug!(request.subdomain)
    end
  end
end

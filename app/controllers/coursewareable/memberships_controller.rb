module Coursewareable
  # Handles Classroom memberships
  class MembershipsController < ApplicationController
    # Abilities checking
    load_and_authorize_resource :class => Coursewareable::Membership

    before_filter :load_classroom, :only => [:destroy]

    # Removes a member
    def destroy
      if @classroom.memberships.destroy(params[:id])
        flash[:success] = _('Member removed successfully.')
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

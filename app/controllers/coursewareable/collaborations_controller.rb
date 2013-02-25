module Coursewareable
  # Handles Classroom collaborations
  class CollaborationsController < ApplicationController
    # Abilities checking
    load_and_authorize_resource :class => Coursewareable::Collaboration
    skip_authorize_resource

    before_filter :load_classroom

    # Handles index listing screen
    def index
      authorize!(:update, @classroom)
    end

    # Handles creation
    def create
      authorize!(:update, @classroom)
      collaboration = @classroom.collaborations.build

      collab = Coursewareable::User.where(:email => params[:email]).first
      if collab.nil?
        invitation = current_user.sent_invitations.create(
          :email => params[:email], :classroom => @classroom,
          :role => Coursewareable::Collaboration.name)
        ::CollaborationMailer.delay.new_invitation_email(invitation)
        flash[:success] = _('An invitation was sent to %s.') % params[:email]
        redirect_to(collaborations_path) and return
      end

      collaboration.user = collab
      if can?(:create, collaboration) and collaboration.save
        flash[:success] = _('%s was added to collaborators') % collab.name
        ::CollaborationMailer.delay.new_collaboration_email(collaboration)
      end

      redirect_to(collaborations_path)
    end

    # Removes a collaborator
    def destroy
      collaboration = @classroom.collaborations.find(params[:id])
      authorize!(:destroy, collaboration)

      collaboration.destroy
      redirect_to collaborations_path
    end

    protected

    # Loads current classroom
    def load_classroom
      @classroom = Coursewareable::Classroom.find_by_slug!(request.subdomain)
    end
  end
end

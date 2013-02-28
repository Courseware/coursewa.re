module Coursewareable
  # Handles Classroom memberships
  class MembershipsController < ApplicationController
    # Abilities checking
    load_and_authorize_resource :class => Coursewareable::Membership
    skip_authorize_resource

    before_filter :load_classroom

    # Handles index listing screen
    def index
      authorize!(:update, @classroom)
    end

    # Handles creation
    def create
      authorize!(:update, @classroom)
      membership = @classroom.memberships.build

      member = Coursewareable::User.where(:email => params[:email]).first
      if member.nil?
        invitation = current_user.sent_invitations.create(
          :email => params[:email], :classroom => @classroom,
          :role => Coursewareable::Membership.name)
        ::MembershipMailer.delay.new_invitation_email(invitation)
        flash[:success] = _('An invitation was sent to %s.') % params[:email]
        redirect_to(memberships_path) and return
      end

      membership.user = member
      if can?(:create, membership) and membership.save
        flash[:success] = _('%s was added to classroom members') % member.name
        ::MembershipMailer.delay.new_member_email(membership)
      end

      redirect_to(memberships_path)
    end

    # Removes a member
    def destroy
      membership = @classroom.memberships.find(params[:id])
      authorize!(:destroy, membership)

      membership.destroy
      redirect_to memberships_path
    end

    protected

    # Loads current classroom
    def load_classroom
      @classroom = Coursewareable::Classroom.find_by_slug!(request.subdomain)
    end
  end
end

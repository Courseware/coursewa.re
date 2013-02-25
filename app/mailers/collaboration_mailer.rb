# Mailer to handle [Coursewareable::Collaboration] emails
class CollaborationMailer < ActionMailer::Base
  default from: Courseware.config.default_email_address
  layout 'email'

  # Sends a welcome email to the newly created collaborator
  #
  # @param [Coursewareable::Collaboration] collaboration, the created object
  def new_collaboration_email(collaboration)
    @classroom = collaboration.classroom
    @user = collaboration.user
    @url = coursewareable.root_url(:subdomain => @classroom.slug)
    subject = _('You can contribute now to %s classroom on %s') % [
      @classroom.title, Courseware.config.domain_name]
    mail(:to => @user.email, :subject => subject)
  end

  # Sends an invitation email to the potential collaborator email
  #
  # @param [Coursewareable::Invitation] invitation, the created object
  def new_invitation_email(invitation)
    @invitation = invitation
    @classroom = invitation.classroom
    @url = coursewareable.signup_url(:subdomain => @classroom.slug)
    subject = _('You were invited as a collaborator for %s classroom on %s') % [
      @classroom.title, Courseware.config.domain_name]
    mail(:to => @invitation.email, :subject => subject)
  end
end

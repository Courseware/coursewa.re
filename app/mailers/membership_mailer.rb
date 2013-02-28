# Mailer to handle [Coursewareable::Membership] emails
class MembershipMailer < ActionMailer::Base
  default from: Courseware.config.default_email_address
  layout 'email'

  # Sends a welcome email to the newly created member
  #
  # @param [Coursewareable::Membership] membership, the created object
  def new_member_email(membership)
    @classroom = membership.classroom
    @user = membership.user
    @url = coursewareable.root_url(:subdomain => @classroom.slug)
    subject = _('You were added to %s classroom on %s') % [
      @classroom.title, Courseware.config.domain_name]
    mail(:to => @user.email, :subject => subject)
  end

  # Sends an invitation email to the potential member email
  #
  # @param [Coursewareable::Invitation] invitation, the created object
  def new_invitation_email(invitation)
    @invitation = invitation
    @classroom = invitation.classroom
    @url = coursewareable.signup_url(:subdomain => @classroom.slug)
    subject = _('You were invited to join %s classroom on %s') % [
      @classroom.title, Courseware.config.domain_name]
    mail(:to => @invitation.email, :subject => subject)
  end
end

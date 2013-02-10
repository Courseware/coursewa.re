# Handles generic emails
class GenericMailer < ActionMailer::Base
  layout 'email'
  default(:from => Courseware.config.default_email_address,
    :reply_to => Courseware.config.support_email_address)

  # Sends an email containing a support query from contact page
  #
  # @param [Hash] params, with email details
  def support_email(params)
    @params = params
    email = 'help@%s' % Courseware.config.domain_name
    mail(:to => email, :subject => _('[%s] %s needs help!') % [
      Courseware.config.domain_name, params[:name]
    ])
  end

  # Sends an email containing a generic query from contact page
  #
  # @param [Hash] params, with email details
  def contact_email(params)
    @params = params
    email = 'hello@%s' % Courseware.config.domain_name
    mail(:to => email, :subject => _('[%s] %s needs attention!') % [
      Courseware.config.domain_name, params[:name]
    ])
  end

  # Sends an email containing an invitation
  #
  # @param [User] user, who sends the invitation
  # @param [Hash] params, with email details
  def invitation_email(user, params)
    @params = params
    subject = _('%s invites you to try Courseware') % [user.name]
    # Since this is an invitation email coming from user initiative,
    # overwrite `reply-to` so that `params[:email]` does not reply to
    # Courseware.config.default_email_address but to user's email address.
    mail(:to => params[:email], :subject => subject, :reply_to => user.email)
  end

  # Sends an email containing a user survey form feedback
  #
  # @param [Hash] params, with email details
  def survey_email(params)
    @params = params
    email = 'help+%s@%s' % [params[:category], Courseware.config.domain_name]
    mail(:to => email, :subject => _('[%s] %s needs help!') % [
      Courseware.config.domain_name, params[:name]
    ])
  end
end

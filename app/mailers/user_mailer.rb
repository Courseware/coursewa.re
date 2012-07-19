# User emails handler class
class UserMailer < ActionMailer::Base
  default from: Courseware.config.default_email_address

  # Sends an activation email to the user
  #
  # @param user {User}, to send email to
  def activation_needed_email(user)
    @user = user
    mail(:to => user.email, :subject => _('Welcome to Courseware'))
  end

  # Sends an activation confirmation email to the user
  #
  # @param user {User}, to send email to
  def activation_success_email(user)
    @user = user
    mail(
      :to => user.email,
      :subject => _('Your Courseware account was activated')
    )
  end

  # Sends a reset password email to the user
  #
  # @param user {User}, to send email to
  def reset_password_email(user)
    @user = user
    mail(
      :to => user.email,
      :subject => _('Your Courseware password has been reset')
    )
  end

end

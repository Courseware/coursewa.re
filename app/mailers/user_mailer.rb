# User emails handler class
class UserMailer < ActionMailer::Base
  default from: Courseware.config.default_email_address

  # Sends an activation email to the user
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.activation_needed_email.subject
  #
  # @param user {User}, to send email to
  def activation_needed_email(user)
    @user = user
    @url  = "http://0.0.0.0:3000/users/#{user.activation_token}/activate"
    mail(to: user.email,
         subject: "Welcome to My Awesome Site")
  end

  # Sends an activation confirmation email to the user
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.activation_success_email.subject
  #
  # @param user {User}, to send email to
  def activation_success_email(user)
    @user = user
    @url  = "http://0.0.0.0:3000/login"
    mail(to: user.email,
         subject: "Your account is now activated")
  end

  # Sends a reset password email to the user
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.reset_password_email.subject
  #
  # @param user {User}, to send email to
  def reset_password_email(user)
    @user = user
    @url  = "http://0.0.0.0:3000/login"
    mail(to: user.email,
         subject: "Your password has been reset")
  end

end

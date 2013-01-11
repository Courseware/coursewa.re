class GenericMailer < ActionMailer::Base
  default from: Courseware.config.default_email_address
  layout 'email'

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
end

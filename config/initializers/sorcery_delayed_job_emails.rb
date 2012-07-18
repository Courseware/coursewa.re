module Sorcery::Model::InstanceMethods
  alias_method(
    :async_send_email, :generic_send_email
  ) if Delayed::Worker.delay_jobs

  def async_send_email(method, mailer)
    config = sorcery_config
    mail = config.send(mailer).delay.send(config.send(method), self)
  end
end

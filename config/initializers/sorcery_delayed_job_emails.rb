module Sorcery
  module Model
    module InstanceMethods
      def generic_send_email(method, mailer)
        config = sorcery_config
        mail = config.send(mailer).delay.send(config.send(method), self)
      end
    end
  end
end


# Handles allowed and denied sub-domains
module Subdomains
  # Handles allowed sub-domains for main site components
  class Allowed
    # Overwrites default method with our custom logic
    #
    # @param [Object] request, the request object to process
    # @return [TrueClass] if request carries a valid sub-domain
    # @return [FalseCalss] if request carries an invalid sub-domain
    def self.matches?(request)
      domains = Courseware.config.domain_blacklist + ['', nil]
      if domains.include?(request.subdomain)
        return true
      end
      return false
    end
  end

  # Handles denied sub-domains for classroom components mainly
  class Forbidden
    # Overwrites default method with our custom logic
    #
    # @param [Object] request, the request object to process
    # @return [TrueClass] if request carries a valid sub-domain
    # @return [FalseCalss] if request carries an invalid sub-domain
    def self.matches?(request)
      domains = Courseware.config.domain_blacklist
      if request.subdomain.blank? or domains.include?(request.subdomain)
        return false
      end
      return true
    end
  end
end

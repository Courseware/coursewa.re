require 'ostruct'

# Courseware configuration entries
module Courseware
  class << self
    attr_reader :config
  end

  @config = OpenStruct.new(
    domain_name: 'coursewa.re',
    default_email_address: 'no-reply@coursewa.re'
  )
end

require 'ostruct'
require 'cancan'
require 'coursewareable'

# Courseware configuration entries
module Courseware
  mattr_accessor :config
end

Courseware.config = Coursewareable.config
%w(domain_name default_email_address support_email_address
  header_image_size).each do |member|
    Courseware.config.member = :none
end

Courseware.config.domain_name = 'coursewa.re'
Courseware.config.default_email_address = 'no-reply@coursewa.re'
Courseware.config.support_email_address = 'help@coursewa.re'
Courseware.config.header_image_size = {:width => 1400, :height => 260}
%w(www expecting enterprise).each do |subdomain|
  Courseware.config.domain_blacklist.push(subdomain)
end

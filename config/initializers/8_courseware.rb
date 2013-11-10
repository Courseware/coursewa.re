require 'ostruct'
require 'cancan'
require 'coursewareable'

# Courseware configuration entries
module Courseware
  mattr_accessor :config
end

Courseware.config = Coursewareable.config

Courseware.config.domain_name = 'open.coursewa.re'
Courseware.config.default_email_address = 'no-reply@open.coursewa.re'
Courseware.config.support_email_address = 'help@open.coursewa.re'
Courseware.config.header_image_size = {:width => 1400, :height => 260}
%w(www expecting enterprise).each do |subdomain|
  Courseware.config.domain_blacklist.push(subdomain)
end

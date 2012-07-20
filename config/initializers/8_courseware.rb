require 'ostruct'

# Courseware configuration entries
module Courseware
  class << self
    attr_reader :config
  end

  @config = OpenStruct.new(
    :domain_name => 'coursewa.re',
    :default_email_address => 'no-reply@coursewa.re',
    :domain_blacklist => %w(blog api support help mail ftp dashboard),
    :plans => {
      :free => {
        :title => _('Free'),
        :allowed_classrooms => 1,
        :allowed_space => 100.megabytes,
        :expires_in => nil,
        :cost => 0
      },
      :micro => {
        :title => _('Micro'),
        :allowed_classrooms => 5,
        :allowed_space => 5.gigabytes,
        :expires_in => 30.days,
        :cost => 7
      },
      :small => {
        :title => _('Small'),
        :allowed_classrooms => 10,
        :allowed_space => 10.gigabytes,
        :expires_in => 30.days,
        :cost => 12
      },
      :medium => {
        :title => _('Medium'),
        :allowed_classrooms => 20,
        :allowed_space => 20.gigabytes,
        :expires_in => 30.days,
        :cost => 22
      }
    }
  )
end

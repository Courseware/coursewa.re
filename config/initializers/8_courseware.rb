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
        :slug => :free,
        :allowed_classrooms => 1,
        :allowed_space => 100.megabytes,
        :expires_in => nil,
        :cost => 0
      },
      :micro => {
        :slug => :micro,
        :allowed_classrooms => 5,
        :allowed_space => 5.gigabytes,
        :expires_in => Time.now + 1.month,
        :cost => 7
      },
      :small => {
        :slug => :small,
        :allowed_classrooms => 10,
        :allowed_space => 10.gigabytes,
        :expires_in => Time.now + 1.month,
        :cost => 12
      },
      :medium => {
        :slug => :medium,
        :allowed_classrooms => 20,
        :allowed_space => 20.gigabytes,
        :expires_in => Time.now + 1.month,
        :cost => 22
      }
    }
  )
end

GravatarImageTag.configure do |config|
  config.default_image           = nil
  config.filetype                = nil
  config.include_size_attributes = true
  config.rating                  = nil
  config.size                    = 40
  config.secure                  = Rails.configuration.force_ssl
end

PartyFoul.configure do |config|
  # the collection of exceptions to be ignored by PartyFoul
  # The constants here *must* be represented as strings
  config.blacklisted_exceptions = %w(
    ActiveRecord::RecordNotFound
    ActionController::RoutingError
  )
  # More below
  # ActionController::InvalidAuthenticityToken
  # ActionController::UnknownAction
  # AbstractController::ActionNotFound

  # The names of the HTTP headers to not report
  # config.filtered_http_headers = ['Cookie']

  # The OAuth token for the account that will be opening the issues on Github
  config.oauth_token        = '4228908ebeccca80d1bac0363d3d774492c290c3'

  # The API endpoint for Github. Unless you are hosting a private
  # instance of Enterprise Github you do not need to include this
  config.endpoint           = 'https://api.github.com'

  # The organization or user that owns the target repository
  config.owner              = 'stas'

  # The repository for this application
  config.repo               = 'coursewa.re'
end if defined?(PartyFoul)

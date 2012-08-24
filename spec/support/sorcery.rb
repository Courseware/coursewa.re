module Sorcery::TestHelpers::Rails
  # Helper method to login with Capybara
  def sign_in_with(email, password='secret', subdomain=nil)
    # Authenticate with Capybara
    page.driver.post(
      sessions_url(:subdomain => subdomain),
      { :email => email, :password => password }
    )
  end
end

RSpec.configure do |config|
  config.include(Sorcery::TestHelpers::Rails, :type => :request)
end

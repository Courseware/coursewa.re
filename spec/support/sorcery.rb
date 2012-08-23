module Sorcery::TestHelpers::Rails
  # Helper method to login with Capybara
  def sign_in_with(email, password, subdomain='www')
    page.driver.post(
      sessions_url(:subdomain => subdomain),
      { :email => email, :password => password }
    )
  end
end

RSpec.configure do |config|
  config.include(Sorcery::TestHelpers::Rails, :type => :request)
end

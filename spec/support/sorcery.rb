module Sorcery::TestHelpers::Rails
  # Helper method to login with Capybara
  def login_user_post(email, password)
    page.driver.post(
      sessions_url, {:email => email, :password => password}
    )
  end
end

RSpec.configure do |config|
  config.include(Sorcery::TestHelpers::Rails)
end

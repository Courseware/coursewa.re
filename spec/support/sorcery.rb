module Sorcery::TestHelpers::Rails
  # Helper method to login with Capybara
  def login_user(email, password)
    page.driver.post(
      sessions_path, {:email => email, :password => password}
    )
    visit root_path
  end
end

RSpec.configure do |config|
  config.include(Sorcery::TestHelpers::Rails, :type => :controller)
end

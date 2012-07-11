module Sorcery
  module TestHelpers
    module Rails
      # Helper method to login with Capybara
      def login_user_post(email, password)
        page.driver.post(
          sessions_url, {:email => email, :password => password}
        )
      end
    end
  end
end

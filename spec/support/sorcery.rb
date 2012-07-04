module Sorcery
  module TestHelpers
    module Rails
      # Helper method to login with Capybara
      def login_user_post(user, password)
        page.driver.post(sessions_url, { username: user, password: password}) 
      end
    end
  end
end

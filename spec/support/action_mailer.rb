RSpec.configure do |config|
  config.before(:all) { ActionMailer::Base.deliveries.clear }
end

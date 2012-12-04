RSpec.configure do |config|
  config.mock_with :rspec

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = ::Coursewareable::Engine.root.join('spec', 'fixtures')

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Add support for named routes
  config.include(Rails.application.routes.url_helpers, :type => :controllers)

  # Basic filter to pick certain specs
  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true
end


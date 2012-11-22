source :rubygems
ruby '1.9.3'

gem 'rails'
gem 'haml-rails'
gem 'jquery-rails'
gem 'delayed_job_active_record'
gem 'gettext_i18n_rails'
gem 'roadie'
gem 'gravatar_image_tag'

# Load the Coursewareable engine
gem 'coursewareable', :git => 'git@github.com:stas/coursewareable.git'

# Speedup a bit things
gem 'multi_json'
gem 'oj'

group :production do
  gem 'pg'
  gem 'puma'
  gem 'aws-sdk'
end

group :development do
  gem 'sqlite3'
  gem 'pry'
  gem 'quiet_assets'
  gem 'rack-bug', :github => 'brynary/rack-bug', :branch => 'rails3'
  gem 'rails-erd'
  gem 'yard', :require => false
  gem 'gettext', :require => false
  gem 'ruby_parser', :require => false
end

group :assets do
  gem 'uglifier'
  gem 'therubyracer'
  gem 'sass-rails'
  gem 'compass-rails'
  gem 'zurb-foundation'
  gem 'turbo-sprockets-rails3'
end

group :development, :test do
  gem 'ffaker'
  gem 'fabrication'
  gem 'guard-spork'
  gem 'guard-rspec'
  gem 'rb-inotify'
  gem 'rspec-rails'
  gem 'letter_opener'
  gem 'shoulda-matchers'
  gem 'database_cleaner'
  gem 'capybara', '2.0.0.beta2'
  gem 'email_spec'
  gem 'simplecov', :require => false
  gem 'tddium', :require => false
end

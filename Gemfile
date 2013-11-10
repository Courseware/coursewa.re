source 'https://rubygems.org'
ruby '2.0.0'

gem 'rails', '~> 3.2'
# Load the Coursewareable engine
gem 'coursewareable', :github => 'Courseware/coursewareable'
gem 'haml-rails'
gem 'jquery-rails'
gem 'delayed_job_active_record'
gem 'gettext_i18n_rails'
gem 'roadie'
gem 'gravatar_image_tag'
gem 'daemons'
gem 'kaminari'
gem 'ruby-oembed'

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
  gem 'quiet_assets'
  gem 'letter_opener'
  # gem 'rails-erd'
  gem 'yard', :require => false
  gem 'gettext', :require => false
  gem 'ruby_parser', :require => false
  gem 'cane'
  gem 'seedbank', '0.3.0.pre'
  gem 'mina', :require => false, :github => 'stas/mina', :branch => 'rbenv_and_ruby-build_support'
  gem 'pry-rails'
end

group :assets do
  gem 'uglifier'
  gem 'therubyracer'
  gem 'sass-rails'
  gem 'compass-rails'
  gem 'zurb-foundation', '~> 3.2'
  gem 'turbo-sprockets-rails3'
  gem 'd3_rails'
end

group :development, :test do
  gem 'ffaker'
  gem 'fabrication'
  gem 'guard-rspec'
  gem 'rb-inotify'
  gem 'rspec-rails'
  gem 'shoulda-matchers'
  gem 'database_cleaner'
  gem 'capybara'
  gem 'email_spec'
  gem 'simplecov', :require => false
  gem 'tddium', :require => false
end

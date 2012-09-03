source 'https://rubygems.org'

gem 'rails'
gem 'haml-rails'
gem 'jquery-rails'
gem 'puma'
gem 'sorcery'
gem 'delayed_job_active_record'
gem 'gettext_i18n_rails'
gem 'roadie'
gem 'cancan'
gem 'public_activity', :github => 'pokonski/public_activity'
gem 'gravatar_image_tag'
gem 'friendly_id'
gem 'paperclip'
gem 'sanitize'
# Speedup a bit things
gem 'multi_json'
gem 'oj'

group :production do
  gem 'pg'
end

group :development do
  gem 'sqlite3'
  gem 'pry'
  gem 'quiet_assets'
  gem 'yard', :require => false
  gem 'gettext', :require => false
  gem 'ruby_parser', :require => false
  gem 'cane', :require => false
end

group :assets do
  gem 'uglifier'
  gem 'therubyracer'
  gem 'sass-rails'
  gem 'compass-rails'
  gem 'zurb-foundation'
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
  gem 'railsonfire', :require => false
end

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.7.1"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem "rails", "~> 6.0.3", ">= 6.0.3.1"
# Use Puma as the app server
gem "puma", "~> 4.1"
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem "webpacker", "~> 4.0"
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem "jbuilder", "~> 2.7"
# Database
gem "mysql2"
gem "sequel-rails", "1.1.1"
gem "sequel_secure_password", "0.2.15"
gem "sequel_polymorphic", "0.5.0"
gem "pagy", "~> 3.8", ">= 3.8.2"
# Background jobs
gem "talentbox-delayed_job_sequel", require: "delayed_job_sequel"
gem "daemons"
# AWS
gem "aws-sdk-s3", "~> 1.71", ">= 1.71.1"

# Debug
gem "pry", require: false

# Reduces boot times through caching; required in config/boot.rb
# gem "bootsnap", ">= 1.4.2", require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  # gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
  gem "faker", "~> 2.12"
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem "web-console", ">= 3.3.0"
  gem "listen", "~> 3.2"
  gem "rufo", "~> 0.12.0"
  gem "victor", "~> 0.3.2"
end

group :test do
  gem "rspec-rails", "~> 4.0", ">= 4.0.1"
  gem "rspec-retry", ">= 0.6.2"
  gem "factory_bot", "~> 6.0", ">= 6.0.2"
  gem "capybara", "~> 3.33"
  gem "webdrivers", "~> 4.4", ">= 4.4.1"
  gem "database_cleaner-sequel", "~> 1.8"
  gem "simplecov", require: false
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]

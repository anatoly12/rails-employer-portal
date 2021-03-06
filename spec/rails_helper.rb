require "simplecov"
SimpleCov.start "rails" if ENV["COVERAGE"]

# This file is copied to spec/ when you run 'rails generate rspec:install'
require "spec_helper"
ENV["RAILS_ENV"] ||= "test"
require File.expand_path("../config/environment", __dir__)
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require "rspec/rails"
require "rspec/retry"
# Add additional requires below this line. Rails is not loaded until this point!
require "capybara/rspec"
require "database_cleaner/sequel"

Capybara.javascript_driver = :selenium_chrome_headless
Capybara.configure do |config|
  config.server = :puma, { Silent: true }
end

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
Dir[Rails.root.join("spec", "support", "**", "*.rb")].sort.each { |f| require f }

RSpec.configure do |config|
  # Remove this line to enable support for ActiveRecord
  config.use_active_record = false

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, type: :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")

  # ~~ Include helpers automatically ~~
  config.include FeatureHelpers, type: :feature
  config.include RequestHelpers, type: :request
  config.include SyncHelpers, type: :sync
  config.include AwsHelpers, type: :aws

  # ~~ Database cleaner ~~
  config.before(:suite) do
    Sequel::Model.db.run("SET FOREIGN_KEY_CHECKS=0")
    DatabaseCleaner.clean_with(:truncation)
    Sequel::Model.db.run("SET FOREIGN_KEY_CHECKS=1")
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, type: :feature) do
    DatabaseCleaner.strategy = :deletion
  end

  config.before(:each, type: :sync) do
    DatabaseCleaner.strategy = :deletion
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.append_after(:each) do
    if ::EmployerPortal::Aws.connected?
      ::EmployerPortal::Aws.disconnect
    end
    if ::EmployerPortal::Sync.connected?
      ::EmployerPortal::Sync::Covid19MessageCode.dataset.delete
      ::EmployerPortal::Sync::Covid19Message.dataset.delete
      ::EmployerPortal::Sync::Account.dataset.delete
      ::EmployerPortal::Sync::PassportProduct.dataset.delete
      ::EmployerPortal::Sync::Kit.dataset.delete
      ::EmployerPortal::Sync::Partner.dataset.delete
      ::EmployerPortal::Sync.disconnect
      Sequel::Model.db.drop_view(
        :dashboard_employees,
        :symptom_logs,
        :symptom_log_entries,
        if_exists: true,
      )
    end
    DatabaseCleaner.clean
    ZipCode::CACHE.clear
  end

  # Only retry when Selenium raises Net::ReadTimeout
  config.exceptions_to_retry = [Net::ReadTimeout]

  # Try twice (= retry once), wait 1 second between tries
  config.around :each, :js do |example|
    example.run_with_retry retry: 2, retry_wait: 1
  end

  # Callback to be run between retries
  config.retry_callback = proc do |example|
    # run some additional clean up task - can be filtered by example metadata
    if example.metadata[:js]
      Capybara.reset!
    end
  end
end

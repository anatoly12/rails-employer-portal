Sequel.database_timezone = :utc

def skip_sync?
  return true if File.basename($0) == "rspec" # bin/rspec
  return false if File.basename($0) == "puma" # bin/puma -C config/puma.rb
  return false if Rails.const_defined?("Server") # bin/rails s
  return false if Rails.const_defined?("Console") # bin/rails c

  tasks = defined?(Rake) ? Rake.application.top_level_tasks : []
  tasks.any? { |task| !task.start_with?("jobs:") } # bin/rails jobs:work
end

Rails.application.reloader.to_prepare do
  ::EmployerPortal::Sync.connect unless skip_sync?
end

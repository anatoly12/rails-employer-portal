def skip_aws?
  basename = File.basename $0
  return true if basename == "rspec" # bin/rspec
  return false if basename == "puma" # bin/puma -C config/puma.rb
  return false if basename == "delayed_job" # bin/delayed_job run
  return false if Rails.const_defined?("Server") # bin/rails s
  return false if Rails.const_defined?("Console") # bin/rails c

  tasks = defined?(Rake) ? Rake.application.top_level_tasks : []
  tasks.any? { |task| !task.start_with?("jobs:") } # bin/rails jobs:work
end

Rails.application.reloader.to_prepare do
  ::EmployerPortal::Aws.connect unless skip_aws?
end

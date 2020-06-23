Sequel.database_timezone = :utc

def in_rake_task?
  cmd = File.basename($0)
  return false if cmd == "puma" || cmd == "delayed_job"

  !Rails.const_defined?("Server") && !Rails.const_defined?("Console")
end

Rails.application.reloader.to_prepare do
  ::EmployerPortal::Sync.init unless in_rake_task?
end

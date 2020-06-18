Sequel.database_timezone = :utc

Rails.application.reloader.to_prepare do
  ::EmployerPortal::RemoteDb.init
end

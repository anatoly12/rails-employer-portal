Rails.application.reloader.to_prepare do
  ::EmployerPortal::Aws.init
end

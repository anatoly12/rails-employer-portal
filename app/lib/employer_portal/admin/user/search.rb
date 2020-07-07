class EmployerPortal::Admin::User::Search < ::EmployerPortal::Admin::Base::Search
  private

  # ~~ overrides for EmployerPortal::Search ~~
  def query_class
    ::EmployerPortal::Query::AdminUser
  end

  def decorator
    ::EmployerPortal::Admin::User::Viewer
  end
end

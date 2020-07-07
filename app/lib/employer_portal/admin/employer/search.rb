class EmployerPortal::Admin::Employer::Search < ::EmployerPortal::Admin::Base::Search
  private

  # ~~ overrides for EmployerPortal::Search ~~
  def query_class
    ::EmployerPortal::Query::Employer
  end

  def decorator
    ::EmployerPortal::Admin::Employer::Viewer
  end
end

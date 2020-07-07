class EmployerPortal::Admin::Employer::Search < ::EmployerPortal::Admin::Base::Search
  private

  # ~~ overrides for EmployerPortal::Admin::Base::Search ~~
  def decorator
    ::EmployerPortal::Admin::Employer::Viewer
  end

  # ~~ overrides for EmployerPortal::Search ~~
  def query_class
    ::EmployerPortal::Query::Employer
  end
end

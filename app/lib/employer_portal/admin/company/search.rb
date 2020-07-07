class EmployerPortal::Admin::Company::Search < ::EmployerPortal::Admin::Base::Search
  private

  # ~~ overrides for EmployerPortal::Admin::Base::Search ~~
  def decorator
    ::EmployerPortal::Admin::Company::Viewer
  end

  # ~~ overrides for EmployerPortal::Search ~~
  def query_class
    ::EmployerPortal::Query::Company
  end
end

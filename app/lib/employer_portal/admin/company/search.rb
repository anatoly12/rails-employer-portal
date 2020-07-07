class EmployerPortal::Admin::Company::Search < ::EmployerPortal::Admin::Base::Search
  private

  # ~~ overrides for EmployerPortal::Search ~~
  def query_class
    ::EmployerPortal::Query::Company
  end

  def decorator
    ::EmployerPortal::Admin::Company::Viewer
  end
end

class EmployerPortal::Admin::Plan::Search < ::EmployerPortal::Admin::Base::Search
  private

  # ~~ overrides for EmployerPortal::Admin::Base::Search ~~
  def decorator
    ::EmployerPortal::Admin::Plan::Viewer
  end

  # ~~ overrides for EmployerPortal::Search ~~
  def query_class
    ::EmployerPortal::Query::Plan
  end
end

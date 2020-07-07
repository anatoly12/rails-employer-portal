class EmployerPortal::Admin::Plan::Search < ::EmployerPortal::Admin::Base::Search
  private

  # ~~ overrides for EmployerPortal::Search ~~
  def query_class
    ::EmployerPortal::Query::Plan
  end

  def decorator
    ::EmployerPortal::Admin::Plan::Viewer
  end
end

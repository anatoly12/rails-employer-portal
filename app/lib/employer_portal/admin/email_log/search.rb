class EmployerPortal::Admin::EmailLog::Search < ::EmployerPortal::Admin::Base::Search
  private

  # ~~ overrides for EmployerPortal::Admin::Base::Search ~~
  def decorator
    ::EmployerPortal::Admin::EmailLog::Viewer
  end

  # ~~ overrides for EmployerPortal::Search ~~
  def query_class
    ::EmployerPortal::Query::EmailLog
  end
end

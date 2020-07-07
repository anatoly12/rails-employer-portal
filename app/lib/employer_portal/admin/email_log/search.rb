class EmployerPortal::Admin::EmailLog::Search < ::EmployerPortal::Admin::Base::Search
  private

  # ~~ overrides for EmployerPortal::Search ~~
  def query_class
    ::EmployerPortal::Query::EmailLog
  end

  def decorator
    ::EmployerPortal::Admin::EmailLog::Viewer
  end
end

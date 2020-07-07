class EmployerPortal::Admin::EmailTemplate::Search < ::EmployerPortal::Admin::Base::Search
  private

  # ~~ overrides for EmployerPortal::Search ~~
  def query_class
    ::EmployerPortal::Query::EmailTemplate
  end

  def decorator
    ::EmployerPortal::Admin::EmailTemplate::Viewer
  end
end

class EmployerPortal::Admin::EmailTemplate::Search < ::EmployerPortal::Admin::Base::Search
  private

  # ~~ overrides for EmployerPortal::Admin::Base::Search ~~
  def decorator
    ::EmployerPortal::Admin::EmailTemplate::Viewer
  end

  # ~~ overrides for EmployerPortal::Search ~~
  def query_class
    ::EmployerPortal::Query::EmailTemplate
  end
end

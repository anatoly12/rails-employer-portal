class EmployerPortal::Admin::Employee::Search < ::EmployerPortal::Admin::Base::Search

  # ~~ overrides for EmployerPortal::Search ~~
  def sort_order
    order = params[:order]
    order = "created:desc" if order.blank? || (order.match(/checkup|testing/) && !context.sync_connected?)
    order
  end

  private

  # ~~ overrides for EmployerPortal::Search ~~
  def query_class
    ::EmployerPortal::Query::Employee
  end

  def decorator
    ::EmployerPortal::Admin::Employee::Viewer
  end
end

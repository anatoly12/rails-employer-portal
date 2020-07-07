class EmployerPortal::Employee::Search < ::EmployerPortal::Search

  # ~~ overrides for EmployerPortal::Search ~~
  def sort_order
    order = params[:order]
    order = "full_name:asc" if order.blank? || (order.match(/checkup|testing/) && !context.sync_connected?)
    order
  end

  private

  # ~~ overrides for EmployerPortal::Search ~~
  def query_class
    ::EmployerPortal::Query::Employee
  end

  def decorator
    ::EmployerPortal::Employee::Viewer
  end
end

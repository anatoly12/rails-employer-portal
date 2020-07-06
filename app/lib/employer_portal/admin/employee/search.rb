class EmployerPortal::Admin::Employee::Search < ::EmployerPortal::Admin::Base::Search
  private

  # ~~ overrides for EmployerPortal::Admin::Base::Search ~~
  def decorator
    ::EmployerPortal::Admin::Employee::Viewer
  end

  # ~~ overrides for EmployerPortal::Search ~~
  def dataset
    ::EmployerPortal::Query::Employee.new(
      context
    ).search_dataset filters.to_hash, sort_order
  end
end

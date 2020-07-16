class EmployerPortal::Employee::Search < ::EmployerPortal::Search

  # ~~ public instance methods ~~
  def empty?
    count == 0 && filters.empty?
  end

  def delete_all
    ds = Employee.where employer_id: context.account_id
    pks = ds.select_map :id
    return 0 unless pks.any?

    ds.delete
    Audit.create(
      item_type: Employee,
      item_id: nil,
      event: "delete_all",
      changes: pks.to_json,
      created_by_type: Sequel::Plugins::WithAudits.created_by_type,
      created_by_id: Sequel::Plugins::WithAudits.created_by_id,
    )
    pks.size
  end

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

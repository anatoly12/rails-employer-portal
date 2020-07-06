class EmployerPortal::Query::Employee
  def initialize(context)
    @context = context
  end

  def search_dataset(filters, sort_order)
    ds = dataset
    filters.reject do |_, value|
      value.blank?
    end.each do |key, value|
      ds = apply_filter(ds, key, value)
    end
    ds = apply_order ds, sort_order
    ds
  end

  def count_by_daily_checkup_status
    dataset.group_by(
      :daily_checkup_status
    ).select(
      :daily_checkup_status,
      Sequel.function(:count, :id).as(:count)
    ).to_hash :daily_checkup_status, :count, all: false
  end

  def count_by_testing_status
    dataset.group_by(
      :testing_status
    ).select(
      :testing_status,
      Sequel.function(:count, :id).as(:count)
    ).to_hash :testing_status, :count, all: false
  end

  private

  attr_reader :context

  def graphs
    res = [:company]
    res << :dashboard_employee if context.sync_connected?
    res
  end

  def graph_aliases
    res = {
      id: [:employees, :id],
      uuid: [:employees, :uuid],
      remote_id: [:employees, :remote_id],
      first_name: [:employees, :first_name],
      last_name: [:employees, :last_name],
      state: [:employees, :state],
      phone: [:employees, :phone],
      created_at: [:employees, :created_at],
      company_id: [:company, :id],
      company_name: [:company, :name],
    }
    res.merge!(
      account_id: [:dashboard_employee, :id],
      daily_checkup_status: [:dashboard_employee, :daily_checkup_status, Sequel.function(:coalesce, Sequel.qualify(:dashboard_employee, :daily_checkup_status), "Did Not Submit")],
      daily_checkup_updated_at: [:dashboard_employee, :daily_checkup_updated_at],
      daily_checkup_action: [:dashboard_employee, :daily_checkup_action, Sequel.function(:coalesce, Sequel.qualify(:dashboard_employee, :daily_checkup_action), "Send Reminder")],
      testing_status: [:dashboard_employee, :testing_status, Sequel.function(:coalesce, Sequel.qualify(:dashboard_employee, :testing_status), "Not Registered")],
      testing_updated_at: [:dashboard_employee, :testing_updated_at],
    ) if context.sync_connected?
    res
  end

  def dataset
    ds = Employee.eager_graph(*graphs).set_graph_aliases(graph_aliases)
    if context.section_application?
      ds.where company_id: context.company_id
    else
      ds.where Sequel.qualify(:company, :deleted_at) => nil
    end
    ds.from_self
  end

  def value_for_ilike(string)
    "%#{string.gsub /([%_\\])/, "\\\\\\1"}%"
  end

  def apply_filter(ds, key, value)
    case key
    when "company_id_equals"
      ds.where company_id: value.to_s
    when "full_name_contains"
      ds.where Sequel.ilike(Sequel.function(:concat, :first_name, " ", :last_name), value_for_ilike(value))
    when "email_contains"
      ds.where Sequel.ilike(:email, value_for_ilike(value))
    when "sync_status_equals"
      case value
      when "1" then ds.exclude remote_id: nil
      when "0" then ds.where remote_id: nil
      end
    when "daily_checkup_status_equals"
      ds.where remote_id: DashboardEmployee.where(daily_checkup_status: value).select(:id) if context.sync_connected?
    when "testing_status_equals"
      ds.where remote_id: DashboardEmployee.where(testing_status: value).select(:id) if context.sync_connected?
    end || ds
  end

  def apply_order(ds, column)
    column = "fullname" if column != "state" && !context.sync_connected?

    case column
    when "state"
      ds.order :state
    when "checkup"
      ds.order :daily_checkup_status
    when "checkup_updated_at"
      ds.order :daily_checkup_updated_at
    when "testing"
      ds.order :testing_status
    when "testing_updated_at"
      ds.order :testing_updated_at
    else # "fullname"
      ds.order Sequel.function(:concat, :first_name, " ", :last_name)
    end
  end
end
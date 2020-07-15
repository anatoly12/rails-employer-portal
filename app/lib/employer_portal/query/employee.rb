class EmployerPortal::Query::Employee < EmployerPortal::Query::Base

  # ~~ public instance methods ~~
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

  # ~~ overrides for EmployerPortal::Query::Base ~~
  def dataset
    ds = Employee.eager_graph(*graphs).set_graph_aliases(graph_aliases)
    if context.section_application?
      ds = ds.where company_id: context.company_id
    else
      ds = ds.where Sequel.qualify(:company, :deleted_at) => nil
    end
    ds.qualify.from_self
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
      ds.where daily_checkup_status: value if context.sync_connected?
    when "testing_status_equals"
      ds.where testing_status: value if context.sync_connected?
    end || ds
  end

  def apply_order(ds, column)
    case column
    when "first_name"
      ds.order(:first_name)
    when "last_name"
      ds.order(:last_name)
    when "full_name"
      ds.order Sequel.function(:concat, :first_name, " ", :last_name)
    when "email"
      ds.order(:email)
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
    else # "created_at"
      ds.order(:created_at, :id)
    end
  end

  # ~~ private instance methods ~~
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
    }
    if context.section_application?
      res.merge!(
        contact_queued_at: [:employees, :contact_queued_at],
        reminder_queued_at: [:employees, :reminder_queued_at],
      )
    else
      res.merge!(
        email: [:employees, :email],
        company_id: [:company, :id],
        company_name: [:company, :name],
      )
    end
    res.merge!(
      account_id: [:dashboard_employee, :id],
      daily_checkup_status: [:dashboard_employee, :daily_checkup_status, Sequel.function(:coalesce, Sequel.qualify(:dashboard_employee, :daily_checkup_status), "Did Not Submit")],
      daily_checkup_updated_at: [:dashboard_employee, :daily_checkup_updated_at],
      testing_status: [:dashboard_employee, :testing_status, Sequel.function(:coalesce, Sequel.qualify(:dashboard_employee, :testing_status), "Not Registered")],
      testing_updated_at: [:dashboard_employee, :testing_updated_at],
    ) if context.sync_connected?
    res
  end
end

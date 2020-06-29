class EmployerPortal::Admin::EmployeeSearch < ::EmployerPortal::Admin::Search

  private

  # ~~ overrides for EmployerPortal::Admin::Search ~~
  def decorator
    ::EmployerPortal::Admin::EmployeeForDashboard
  end

  def dataset
    if context.sync_connected?
      Employee.eager(:company, :dashboard_employee)
    else
      Employee.eager(:company)
    end
  end

  def apply_filter(ds, key, value)
    case key
    when "company_id_equals"
      ds.where(company_id: value.to_s)
    when "full_name_contains"
      if context.sync_connected?
        ds.where(
          remote_id: DashboardEmployee.where(
            Sequel.ilike(
              :full_name,
              filters.value_for_ilike(value)
            )
          ).select(:id)
        )
      else
        ds.where(
          Sequel.ilike(
            Sequel.function(:concat, :first_name, " ", :last_name),
            filters.value_for_ilike(value)
          )
        )
      end
    when "email_contains"
      ds.where(
        Sequel.ilike(:email, filters.value_for_ilike(value))
      )
    when "daily_checkup_status_equals"
      if context.sync_connected?
        ds.where(
          remote_id: DashboardEmployee.where(
            daily_checkup_status: value
          ).select(:id)
        )
      else
        ds
      end
    when "testing_status_equals"
      if context.sync_connected?
        ds = ds.where(
          remote_id: DashboardEmployee.where(
            testing_status: value
          ).select(:id)
        )
      else
        ds
      end
    else
      ds
    end
  end

  def apply_order(ds, column)
    case column
    when "first_name"
      ds.order(:first_name)
    when "last_name"
      ds.order(:last_name)
    when "email"
      ds.order(:email)
    when "created_at"
      ds.order(:created_at)
    else
      ds
    end
  end
end

class EmployerPortal::Admin::EmployerSearch < ::EmployerPortal::Admin::Search

  private

  # ~~ overrides for EmployerPortal::Admin::Search ~~
  def decorator
    ::EmployerPortal::Admin::EmployerForDashboard
  end

  def dataset
    Employer.eager(:company)
  end

  def apply_filter(ds, key, value)
    case key
    when "company_id_equals"
      ds.where(company_id: value.to_s)
    when "full_name_contains"
      ds.where(
        Sequel.ilike(
          Sequel.function(:concat, :first_name, " ", :last_name),
          filters.value_for_ilike(value)
        )
      )
    when "email_contains"
      ds.where(
        Sequel.ilike(:email, filters.value_for_ilike(value))
      )
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

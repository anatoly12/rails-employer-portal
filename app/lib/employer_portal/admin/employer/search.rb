class EmployerPortal::Admin::Employer::Search < ::EmployerPortal::Admin::Base::Search
  private

  # ~~ overrides for EmployerPortal::Admin::Base::Search ~~
  def decorator
    ::EmployerPortal::Admin::Employer::Viewer
  end

  # ~~ overrides for EmployerPortal::Search ~~
  def dataset
    Employer.where(deleted_at: nil).qualify.eager(:company)
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
      ds.where Sequel.ilike(:email, filters.value_for_ilike(value))
    end || ds
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
      ds.order(:created_at, :id)
    else
      ds
    end
  end
end

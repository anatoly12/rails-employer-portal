class EmployerPortal::Admin::EmailTemplate::Search < ::EmployerPortal::Admin::Base::Search
  private

  # ~~ overrides for EmployerPortal::Admin::Base::Search ~~
  def decorator
    ::EmployerPortal::Admin::EmailTemplate::Viewer
  end

  def dataset
    EmailTemplate.where(deleted_at: nil).qualify.eager(:plan)
  end

  def apply_filter(ds, key, value)
    case key
    when "plan_id_equals"
      ds.where plan_id: value.to_s
    when "name_contains"
      ds.where Sequel.ilike(:name, filters.value_for_ilike(value))
    end || ds
  end

  def apply_order(ds, column)
    case column
    when "name"
      ds.order(:name)
    when "created_at"
      ds.order(:created_at)
    else
      ds
    end
  end
end

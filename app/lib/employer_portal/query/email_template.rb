class EmployerPortal::Query::EmailTemplate < EmployerPortal::Query::Base
  private

  # ~~ overrides for EmployerPortal::Query::Base ~~
  def dataset
    EmailTemplate.where(deleted_at: nil).qualify
  end

  def apply_filter(ds, key, value)
    case key
    when "plan_id_equals"
      ds.where plan_id: value.to_s
    when "name_contains"
      ds.where Sequel.ilike(:name, value_for_ilike(value))
    end || ds
  end

  def apply_order(ds, column)
    case column
    when "name"
      ds.order(:name)
    else # "created_at"
      ds.order(:created_at, :id)
    end
  end
end

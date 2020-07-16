class EmployerPortal::Query::AdminUser < EmployerPortal::Query::Base
  private

  # ~~ overrides for EmployerPortal::Query::Base ~~
  def dataset
    AdminUser
  end

  def apply_order(ds, column)
    case column
    when "email"
      ds.order(:email)
    else # "created_at"
      ds.order(:created_at, :id)
    end
  end
end

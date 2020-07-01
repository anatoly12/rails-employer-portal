class EmployerPortal::Admin::EmailTemplateSearch < ::EmployerPortal::Admin::Search
  private

  # ~~ overrides for EmployerPortal::Admin::Search ~~
  def decorator
    ::EmployerPortal::Admin::EmailTemplateForDashboard
  end

  def dataset
    EmailTemplate.where(deleted_at: nil).qualify
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

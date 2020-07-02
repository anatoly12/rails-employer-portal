class EmployerPortal::Admin::Plan::Search < ::EmployerPortal::Admin::Base::Search
  private

  # ~~ overrides for EmployerPortal::Admin::Base::Search ~~
  def decorator
    ::EmployerPortal::Admin::Plan::Viewer
  end

  def dataset
    Plan.
      where(deleted_at: nil).
      qualify.
      eager_graph(:undeleted_companies, :undeleted_email_templates).
      group_by(Sequel.qualify(:plans, :id)).
      set_graph_aliases(
      created_at: [:plans, :created_at],
      id: [:plans, :id],
      name: [:plans, :name],
      daily_checkup_enabled: [:plans, :daily_checkup_enabled],
      testing_enabled: [:plans, :testing_enabled],
      health_passport_enabled: [:plans, :health_passport_enabled],
      employer_limit: [:plans, :employer_limit],
      employee_limit: [:plans, :employee_limit],
      company_count: [:plans, :company_count, Sequel.function(:count, Sequel.qualify(:undeleted_companies, :id)).distinct],
      email_template_count: [:plans, :email_template_count, Sequel.function(:count, Sequel.qualify(:undeleted_email_templates, :id)).distinct],
    )
  end

  def apply_order(ds, column)
    ds = case column
      when "name"
        ds.order(:name)
      when "created_at"
        ds.order(:created_at)
      else
        ds
      end
  end
end

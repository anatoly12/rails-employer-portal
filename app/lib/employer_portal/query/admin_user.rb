class EmployerPortal::Query::AdminUser < EmployerPortal::Query::Base
  private

  # ~~ overrides for EmployerPortal::Query::Base ~~
  def dataset
    AdminUser
  end

  def apply_filter(ds, _key, _value)
    ds
  end

  def apply_order(ds, column)
    case column
    when "email"
      ds.order(:email)
    else # "created_at"
      ds.order(:created_at, :id)
    end
  end

  # ~~ private instance methods ~~
  def graphs
    [:undeleted_companies, :undeleted_email_templates]
  end

  def graph_aliases
    {
      id: [:plans, :id],
      name: [:plans, :name],
      daily_checkup_enabled: [:plans, :daily_checkup_enabled],
      testing_enabled: [:plans, :testing_enabled],
      health_passport_enabled: [:plans, :health_passport_enabled],
      employer_limit: [:plans, :employer_limit],
      employee_limit: [:plans, :employee_limit],
      created_at: [:plans, :created_at],
      company_count: [:plans, :company_count, Sequel.function(:count, Sequel.qualify(:undeleted_companies, :id)).distinct],
      email_template_count: [:plans, :email_template_count, Sequel.function(:count, Sequel.qualify(:undeleted_email_templates, :id)).distinct],
    }
  end
end

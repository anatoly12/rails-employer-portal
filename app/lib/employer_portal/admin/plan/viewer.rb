class EmployerPortal::Admin::Plan::Viewer < ::EmployerPortal::Admin::Base::Viewer
  # ~~ delegates ~~
  delegate :name, :daily_checkup_enabled, :testing_enabled,
    :health_passport_enabled, to: :decorated

  # ~~ public instance methods ~~
  def employer_limit
    decorated.employer_limit > 0 ? decorated.employer_limit : "Unlimited"
  end

  def employee_limit
    decorated.employee_limit > 0 ? decorated.employee_limit : "Unlimited"
  end

  def company_count
    decorated.values[:company_count]
  end

  def email_template_count
    decorated.values[:email_template_count]
  end
end

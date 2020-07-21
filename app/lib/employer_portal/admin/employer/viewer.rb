class EmployerPortal::Admin::Employer::Viewer < ::EmployerPortal::Admin::Base::Viewer

  # ~~ delegates ~~
  delegate :first_name, :last_name, :email, :allowed_to_add_employees, :allowed_to_add_employee_tags, :allowed_all_employee_tags, :allowed_employee_tags, to: :decorated

  # ~~ public instance methods ~~
  def role
    decorated.role.humanize
  end

  def company_name
    decorated.company.name
  end
end

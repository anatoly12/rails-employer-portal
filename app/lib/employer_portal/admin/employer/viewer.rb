class EmployerPortal::Admin::Employer::Viewer < ::EmployerPortal::Admin::Base::Viewer
  # ~~ delegates ~~
  delegate :first_name, :last_name, :email, to: :decorated

  # ~~ public instance methods ~~
  def role
    decorated.role.humanize
  end

  def company_name
    decorated.company.name
  end
end

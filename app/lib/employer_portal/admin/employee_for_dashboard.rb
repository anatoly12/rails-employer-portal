class EmployerPortal::Admin::EmployeeForDashboard < ::EmployerPortal::Admin::Viewer
  # ~~ delegates ~~
  delegate :first_name, :last_name, :email, to: :decorated
  delegate :daily_checkup_status, :testing_status, to: :dashboard_employee

  # ~~ public instance methods ~~
  def company_name
    decorated.company.name
  end

  def full_name
    dashboard_employee ? dashboard_employee.full_name : "#{first_name} #{last_name}"
  end

  private

  # ~~ private instance methods ~~
  def dashboard_employee
    decorated.dashboard_employee if context.sync_connected?
  end
end

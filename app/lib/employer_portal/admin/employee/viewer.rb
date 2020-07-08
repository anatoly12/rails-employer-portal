class EmployerPortal::Admin::Employee::Viewer < ::EmployerPortal::Admin::Base::Viewer

  # ~~ delegates ~~
  delegate :first_name, :last_name, :email, :remote_id, to: :decorated

  # ~~ public instance methods ~~
  def company_name
    decorated.company.name
  end

  def full_name
    dashboard_employee&.full_name || "#{first_name} #{last_name}"
  end

  def daily_checkup_status
    dashboard_employee&.daily_checkup_status || "Did Not Submit"
  end

  def testing_status
    dashboard_employee&.testing_status || "Not Registered"
  end

  private

  # ~~ private instance methods ~~
  def dashboard_employee
    decorated.dashboard_employee if context.sync_connected?
  end
end

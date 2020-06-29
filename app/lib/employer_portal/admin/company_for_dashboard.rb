class EmployerPortal::Admin::CompanyForDashboard < ::EmployerPortal::Admin::Viewer
  # ~~ delegates ~~
  delegate :name, :plan, to: :decorated

  # ~~ public instance methods ~~
  def employer_count
    decorated.values[:employer_count]
  end

  def employee_count
    decorated.values[:employee_count]
  end
end

class EmployerPortal::Admin::Company::Viewer < ::EmployerPortal::Admin::Base::Viewer
  # ~~ delegates ~~
  delegate :name, to: :decorated

  # ~~ public instance methods ~~
  def plan_name
    decorated.plan.name
  end

  def employer_count
    decorated.values[:employer_count]
  end

  def employee_count
    decorated.values[:employee_count]
  end
end

class EmployerPortal::Admin::DashboardStats

  # ~~ public instance methods ~~
  def initialize(context)
    @context = context
  end

  def company_count
    @company_count ||= Company.count
  end

  def employer_count
    @employer_count ||= Employer.count
  end

  def employee_count
    @employee_count ||= Employee.count
  end

  def no_symptoms_count
    count_by_daily_checkup_status.fetch("Cleared", 0)
  end

  def symptoms_count
    count_by_daily_checkup_status.fetch("Not Cleared", 0)
  end

  def did_not_submit_count
    count_by_daily_checkup_status.fetch("Did Not Submit", 0)
  end

  def cleared_count
    count_by_testing_status.fetch("Cleared", 0)
  end

  def inconclusive_count
    count_by_testing_status.fetch("Inconclusive", 0)
  end

  def submitted_results_count
    count_by_testing_status.fetch("Submitted Results", 0)
  end

  def intake_count
    count_by_testing_status.fetch("Intake", 0)
  end

  def registered_count
    count_by_testing_status.fetch("Registered", 0)
  end

  def not_registered_count
    count_by_testing_status.fetch("Not Registered", 0)
  end

  private

  attr_reader :context

  # ~~ private instance methods ~~
  def dataset
    DashboardEmployee.inner_join(:employees, remote_id: :id)
  end

  def count_by_daily_checkup_status
    @count_by_daily_checkup_status ||= dataset.group_and_count(
      :daily_checkup_status
    ).to_a.each_with_object({}) do |raw, hash|
      hash[raw[:daily_checkup_status]] = raw[:count]
    end
  end

  def count_by_testing_status
    @count_by_testing_status ||= dataset.where(
      Sequel.qualify(:employees, :company_id) => Company.exclude(
        plan: "Lite",
      ).select(:id),
    ).group_and_count(
      :testing_status
    ).to_a.each_with_object({}) do |raw, hash|
      hash[raw[:testing_status]] = raw[:count]
    end
  end
end

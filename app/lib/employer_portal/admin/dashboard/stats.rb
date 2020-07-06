class EmployerPortal::Admin::Dashboard::Stats

  # ~~ public instance methods ~~
  def initialize(context)
    @context = context
  end

  def plan_count
    @plan_count ||= Plan.where(deleted_at: nil).count
  end

  def company_count
    @company_count ||= Company.where(deleted_at: nil).count
  end

  def employer_count
    @employer_count ||= Employer.where(
      deleted_at: nil,
    ).qualify.inner_join(
      :companies,
      id: :company_id,
      deleted_at: nil,
    ).count
  end

  def employee_count
    @employee_count ||= Employee.inner_join(
      :companies,
      id: :company_id,
      deleted_at: nil,
    ).count
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
    @count_by_daily_checkup_status ||= dataset.where(
      Sequel.qualify(:employees, :company_id) => Company.where(
        deleted_at: nil,
      ).select(:id),
    ).group_by(:daily_checkup_status).select(
      :daily_checkup_status,
      Sequel.function(:count, Sequel.qualify(:employees, :id)).as(:count)
    ).to_hash :daily_checkup_status, :count
  end

  def count_by_testing_status
    @count_by_testing_status ||= dataset.where(
      Sequel.qualify(:employees, :company_id) => Company.where(
        deleted_at: nil,
      ).select(:id),
    ).group_by(:testing_status).select(
      :testing_status,
      Sequel.function(:count, Sequel.qualify(:employees, :id)).as(:count)
    ).to_hash :testing_status, :count
  end
end

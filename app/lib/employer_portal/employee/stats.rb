class EmployerPortal::Employee::Stats

  # ~~ public instance methods ~~
  def initialize(context)
    @context = context
  end

  def no_symptoms_count
    return 0 unless context.sync_connected? && total > 0

    count_by_daily_checkup_status.fetch "Cleared", 0
  end

  def symptoms_count
    return 0 unless context.sync_connected? && total > 0

    count_by_daily_checkup_status.fetch "Not Cleared", 0
  end

  def did_not_submit_count
    total - no_symptoms_count - symptoms_count
  end

  def cleared_count
    return 0 unless context.sync_connected? && total > 0

    count_by_testing_status.fetch "Cleared", 0
  end

  def inconclusive_count
    return 0 unless context.sync_connected? && total > 0

    count_by_testing_status.fetch "Inconclusive", 0
  end

  def in_progress_count
    total - cleared_count - inconclusive_count
  end

  def total
    @total ||= count_by_daily_checkup_status.values.sum
  end

  def daily_checkup_available_count
    daily_checkup_allowed_count - total
  end

  def daily_checkup_limited?
    employee_limit > 0
  end

  def daily_checkup_allowed_count
    employee_limit
  end

  def testing_available_count
    testing_allowed_count - total
  end

  def testing_limited?
    employee_limit > 0
  end

  def testing_allowed_count
    employee_limit
  end

  private

  attr_reader :context

  # ~~ private instance methods ~~
  def employee_limit
    @employee_limit ||= context.company&.plan&.employee_limit || 0
  end

  def query
    ::EmployerPortal::Query::Employee.new context
  end

  def count_by_daily_checkup_status
    @count_by_daily_checkup_status ||= query.count_by_daily_checkup_status
  end

  def count_by_testing_status
    @count_by_testing_status ||= query.count_by_testing_status
  end
end

class EmployerPortal::Query::SymptomLog < EmployerPortal::Query::Base

  # ~~ public instance methods ~~
  def initialize(context, employee)
    super context
    @employee = employee
  end

  private

  attr_reader :employee

  # ~~ overrides for EmployerPortal::Query::Base ~~
  def dataset
    SymptomLog.where(account_id: employee.remote_id).from_self
  end

  def apply_filter(ds, key, value)
    case key
    when "date_equals"
      ds.where Sequel.function(:date, :log_date) => value.to_s
    end || ds
  end

  def apply_order(ds, column)
    ds.order :log_date
  end
end

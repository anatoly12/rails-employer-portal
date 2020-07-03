class EmployerPortal::Admin::EmailLog::Search < ::EmployerPortal::Admin::Base::Search
  private

  # ~~ overrides for EmployerPortal::Admin::Base::Search ~~
  def decorator
    ::EmployerPortal::Admin::EmailLog::Viewer
  end

  def dataset
    EmailLog.eager :company
  end

  def apply_filter(ds, key, value)
    case key
    when "sent_at_gte"
      ds.where Sequel.function(:date, :created_at) >= value.to_s
    when "sent_at_lte"
      ds.where Sequel.function(:date, :created_at) <= value.to_s
    when "company_id_equals"
      ds.where company_id: value.to_s
    when "employer_id_equals"
      ds.where employer_id: value.to_s
    when "employee_id_equals"
      ds.where employee_id: value.to_s
    when "trigger_key_equals"
      ds.where trigger_key: value.to_s
    when "recipient_contains"
      ds.where Sequel.ilike(:recipient, filters.value_for_ilike(value))
    end || ds
  end

  def apply_order(ds, column)
    ds.order :created_at, :id
  end
end

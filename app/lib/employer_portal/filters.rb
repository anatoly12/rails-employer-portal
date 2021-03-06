class EmployerPortal::Filters
  # ~~ constants ~~
  DELEGATE_TO_SEARCH_PATTERN = /(?:_equals|_contains|_gte|_lte|_does_not_equal)\z/

  # ~~ public instance methods ~~
  def initialize(context, filters)
    @context = context
    @filters = filters
  end

  def errors_on(_)
    nil
  end

  def empty?
    filters.blank?
  end

  def plans_for_select
    Plan.where(deleted_at: nil).all.map do |plan|
      [plan.name, plan.id]
    end
  end

  def companies_for_select
    Company.where(deleted_at: nil).all.map do |company|
      [company.name, company.id]
    end
  end

  def sync_statuses_for_select
    [
      ["Synced", "1"],
      ["Not synced", "0"],
    ]
  end

  def daily_checkup_statuses_for_select
    [
      "Cleared",
      "Not Cleared",
      "Did Not Submit",
    ]
  end

  def testing_statuses_for_select
    [
      "Cleared",
      "Inconclusive",
      "Submitted Results",
      "Intake",
      "Registered",
      "Not Registered",
    ]
  end

  def trigger_keys_for_select
    [
      ["Admin user invites a new employer", EmailTemplate::TRIGGER_EMPLOYER_NEW],
      ["Employer password forgotten", EmailTemplate::TRIGGER_EMPLOYER_PASSWORD_FORGOTTEN],
      ["Employer invites a new employee", EmailTemplate::TRIGGER_EMPLOYEE_NEW],
      ["Contact employee when symptomatic", EmailTemplate::TRIGGER_EMPLOYEE_CONTACT],
      ["Remind employee to enter daily symptom checkup", EmailTemplate::TRIGGER_EMPLOYEE_REMINDER],
    ]
  end

  def clearable?
    filters.to_unsafe_h.any? { |key, value| key != "opened" && value.present? }
  end

  def method_missing(name, *args, &block)
    case name.to_s
    when DELEGATE_TO_SEARCH_PATTERN
      filters[name]
    else
      super
    end
  end

  def respond_to_missing?(name, include_private = false)
    name.to_s =~ DELEGATE_TO_SEARCH_PATTERN || super
  end

  def to_hash
    filters.reject { |_, value| value.blank? }
  end

  def employee_tags_for_select
    employee_tag.for_select
  end

  private

  attr_reader :context, :filters

  def employee_tag
    @employee_tag ||= ::EmployerPortal::EmployeeTag.new context
  end
end

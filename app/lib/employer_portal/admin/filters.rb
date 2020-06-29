class EmployerPortal::Admin::Filters
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

  def companies_for_select
    Company.all.map do |company|
      [company.name, company.id]
    end
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

  def value_for_ilike(string)
    "%#{escape_for_like(string)}%"
  end

  def clearable?
    filters.to_unsafe_h.any?{|key, _| key!="opened" }
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
    name.to_s=~DELEGATE_TO_SEARCH_PATTERN || super
  end

  private

  attr_reader :context, :filters

  def escape_for_like(string)
    string.gsub /([%_\\])/, "\\\\\\1"
  end
end

class EmployerPortal::SymptomLog::Search < ::EmployerPortal::Search

  # ~~ accessors ~~
  attr_reader :employee

  # ~~ public instance methods ~~
  def initialize(context, employee, params)
    @employee = employee
    super context, params
  end

  def sort_order
    params[:order] || "log_date:desc"
  end

  private

  # ~~ overrides for EmployerPortal::Search ~~
  def default_page_size
    5
  end

  def query_class
    ::EmployerPortal::Query::SymptomLog
  end

  def query
    @query ||= query_class.new context, employee
  end

  def decorator
    ::EmployerPortal::SymptomLog::Viewer
  end
end

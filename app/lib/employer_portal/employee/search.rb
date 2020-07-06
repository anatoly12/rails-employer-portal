class EmployerPortal::Employee::Search < ::EmployerPortal::Search
  # ~~ overrides for EmployerPortal::Search ~~
  def sort_order
    params[:order] || "fullname:asc"
  end

  def results
    super.map do |result|
      ::EmployerPortal::Employee::Viewer.new(
        context,
        result,
        last_contacted_at(result),
        last_reminded_at(result)
      )
    end
  end

  def stats
    @stats ||= ::EmployerPortal::Employee::Stats.new context
  end

  private

  attr_reader :context, :params

  # ~~ overrides for Pagy ~~
  def pagy_get_vars(collection, vars)
    {
      count: collection.count,
      page: params["page"],
      items: vars[:items] || DEFAULT_PAGE_SIZE,
    }
  end

  # ~~ private instance methods ~~
  def query
    ::EmployerPortal::Query::Employee.new context
  end

  def dataset
    query.search_dataset({}, sort_order)
  end

  def last_trigger_by_employee_and_key
    return {} if @results.empty?

    @last_trigger_by_employee_and_key ||= EmailLog.where(
      employee_id: @results.map(&:id),
      trigger_key: [
        EmailTemplate::TRIGGER_EMPLOYEE_CONTACT,
        EmailTemplate::TRIGGER_EMPLOYEE_REMINDER,
      ],
    ).group_by(
      :employee_id,
      :trigger_key
    ).select(
      :employee_id,
      :trigger_key,
      Sequel.function(:max, :created_at).as(:max)
    ).to_hash [:employee_id, :trigger_key], :max
  end

  def last_contacted_at(employee)
    last_trigger_by_employee_and_key[
      [employee[:id], EmailTemplate::TRIGGER_EMPLOYEE_CONTACT]
    ]
  end

  def last_reminded_at(employee)
    last_trigger_by_employee_and_key[
      [employee[:id], EmailTemplate::TRIGGER_EMPLOYEE_REMINDER]
    ]
  end
end

class EmployerPortal::Employee::Search
  include Pagy::Backend

  # ~~ constants ~~
  DEFAULT_PAGE_SIZE = 50

  # ~~ accessors ~~
  attr_reader :pagination

  # ~~ delegates ~~
  delegate :count, to: :pagination

  # ~~ public class methods ~~
  def self.from_params(context, params)
    new context, params.permit(:filters, :order, :page)
  end

  # ~~ public instance methods ~~
  def initialize(context, params)
    @context = context
    @params = params
    @pagination, @results = pagy(sorted(dataset))
  end

  def sort_order
    params[:order] || "fullname:asc"
  end

  def results
    @results.map do |employee|
      ::EmployerPortal::Employee::Viewer.new(
        context,
        employee,
        last_contacted_at(employee),
        last_reminded_at(employee)
      )
    end
  end

  def stats
    @stats ||= ::EmployerPortal::Employee::Stats.new context, dataset
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
  def dataset
    ds = Employee.where(
      company_id: context.account.company_id,
    ).qualify
    if context.sync_connected?
      ds.eager_graph(:dashboard_employee).select(
        Sequel.qualify(:employees, :id),
        Sequel.qualify(:employees, :uuid),
        Sequel.qualify(:employees, :remote_id),
        Sequel.function(:concat, Sequel.qualify(:employees, :first_name), " ", Sequel.qualify(:employees, :last_name)).as(:full_name),
        Sequel.qualify(:dashboard_employee, :selfie_s3_key),
        Sequel.qualify(:employees, :state),
        Sequel.function(:coalesce,
                        Sequel.qualify(:dashboard_employee, :daily_checkup_status),
                        "Did Not Submit").as(:daily_checkup_status),
        Sequel.qualify(:dashboard_employee, :daily_checkup_updated_at),
        Sequel.function(:coalesce,
                        Sequel.qualify(:dashboard_employee, :daily_checkup_action),
                        "Send Reminder").as(:daily_checkup_action),
        Sequel.function(:coalesce,
                        Sequel.qualify(:dashboard_employee, :testing_status),
                        "Not Registered").as(:testing_status),
        Sequel.qualify(:dashboard_employee, :testing_updated_at)
      )
    else
      ds.select(
        Sequel.qualify(:employees, :id),
        Sequel.qualify(:employees, :uuid),
        Sequel.qualify(:employees, :remote_id),
        Sequel.function(:concat, Sequel.qualify(:employees, :first_name), " ", Sequel.qualify(:employees, :last_name)).as(:full_name),
        Sequel.qualify(:employees, :state).as(:state),
        Sequel.as("Did Not Submit", :daily_checkup_status),
        Sequel.as(nil, :daily_checkup_updated_at),
        Sequel.as("Not Registered", :testing_status),
        Sequel.as(nil, :testing_updated_at)
      )
    end
  end

  def sorted(ds)
    column, direction = sort_order.split(":")
    ds = case column
      when "state"
        ds.order(:state)
      when "checkup"
        ds.order(:daily_checkup_status)
      when "checkup_updated_at"
        ds.order(:daily_checkup_updated_at)
      when "testing"
        ds.order(:testing_status)
      when "testing_updated_at"
        ds.order(:testing_updated_at)
      else # fullname"
        ds.order(:full_name)
      end
    direction == "desc" ? ds.reverse : ds
  end

  def last_trigger_by_employee_and_key
    return {} if @results.empty?

    @last_trigger_by_employee_and_key ||= EmailLog.where(
      employee_id: @results.map{|result| result[:id]},
      trigger_key: [
        EmailTemplate::TRIGGER_EMPLOYEE_CONTACT,
        EmailTemplate::TRIGGER_EMPLOYEE_REMINDER
      ]
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

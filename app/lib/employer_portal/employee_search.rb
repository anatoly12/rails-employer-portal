module EmployerPortal
  class EmployeeSearch
    include Pagy::Backend

    # ~~ constants ~~
    DEFAULT_PAGE_SIZE = 50

    # ~~ accessors ~~
    attr_reader :pagination

    # ~~ delegates ~~
    delegate :count, to: :pagination

    # ~~ public instance methods ~~
    def initialize(context, params)
      @context = context
      @params = params.permit(:filters, :order, :page)
      @pagination, @results = pagy(sorted(dataset))
    end

    def sort_order
      params[:order] || "fullname:asc"
    end

    def results
      @results.map do |employee|
        ::EmployerPortal::EmployeeForDashboard.new context, employee
      end
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
    def connected?
      ::EmployerPortal::Sync.connected?
    end

    def dataset
      ds = Employee.where(
        company_id: context.account.company_id
      ).qualify
      if connected?
        ds.eager_graph(:dashboard_employee).select(
          Sequel.qualify(:employees, :uuid),
          Sequel.function(:coalesce,
            Sequel.qualify(:dashboard_employee, :full_name),
            Sequel.function(:concat, Sequel.qualify(:employees, :first_name), " ", Sequel.qualify(:employees, :last_name))
          ).as(:full_name),
          Sequel.qualify(:dashboard_employee, :selfie_s3_key),
          Sequel.function(:coalesce,
            Sequel.qualify(:dashboard_employee, :state),
            Sequel.qualify(:employees, :state)
          ).as(:state),
          Sequel.function(:coalesce,
            Sequel.qualify(:dashboard_employee, :daily_checkup_status),
            "Did Not Submit"
          ).as(:daily_checkup_status),
          Sequel.function(:coalesce,
            Sequel.qualify(:dashboard_employee, :daily_checkup_updated_at),
            Sequel.qualify(:employees, :created_at)
          ).as(:daily_checkup_updated_at),
          Sequel.function(:coalesce,
            Sequel.qualify(:dashboard_employee, :daily_checkup_action),
            "Send Reminder"
          ).as(:daily_checkup_action),
          Sequel.function(:coalesce,
            Sequel.qualify(:dashboard_employee, :testing_status),
            "Not Registered"
          ).as(:testing_status),
          Sequel.function(:coalesce,
            Sequel.qualify(:dashboard_employee, :testing_updated_at),
            Sequel.qualify(:employees, :created_at)
          ).as(:testing_updated_at)
        )
      else
        ds.select(
          Sequel.qualify(:employees, :uuid),
          Sequel.function(:concat, Sequel.qualify(:employees, :first_name), " ", Sequel.qualify(:employees, :last_name)).as(:full_name),
          Sequel.qualify(:employees, :state).as(:state),
          Sequel.as("Did Not Submit", :daily_checkup_status),
          Sequel.qualify(:employees, :created_at).as(:daily_checkup_updated_at),
          Sequel.as("Not Registered", :testing_status),
          Sequel.qualify(:employees, :created_at).as(:testing_updated_at)
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
      direction=="desc" ? ds.reverse : ds
    end
  end
end

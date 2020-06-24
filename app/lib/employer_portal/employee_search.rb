module EmployerPortal
  class EmployeeSearch
    include Pagy::Backend

    # ~~ accessors ~~
    attr_reader :results, :pagination

    # ~~ delegates ~~
    delegate :count, to: :pagination

    # ~~ public instance methods ~~
    def initialize(context, params)
      @context = context
      @params = params
      @pagination, @results = pagy(dataset)
    end

    def sort_order
      params[:order] || "fullname:asc"
    end

    private

    attr_reader :context, :params

    # ~~ overrides for Pagy ~~
    def pagy_get_vars(collection, vars)
      {
        count: collection.count,
        page: params["page"],
        items: vars[:items] || 2,
      }
    end

    # ~~ private instance methods ~~
    def dataset
      Employee.left_join(
        :dashboard_employees,
        id: Sequel.qualify(:employees, :remote_id)
      ).where(
        company_id: context.account.company_id
      ).select(
        Sequel.qualify(:employees, :email),
        Sequel.function(:coalesce,
          Sequel.qualify(:dashboard_employees, :full_name),
          Sequel.function(:concat, Sequel.qualify(:employees, :first_name), " ", Sequel.qualify(:employees, :last_name))
        ).as(:full_name),
        Sequel.qualify(:dashboard_employees, :selfie_s3_key),
        Sequel.function(:coalesce,
          Sequel.qualify(:dashboard_employees, :state),
          Sequel.qualify(:employees, :state)
        ).as(:state),
        Sequel.function(:coalesce,
          Sequel.qualify(:dashboard_employees, :daily_checkup_status),
          "Did Not Submit"
        ).as(:daily_checkup_status),
        Sequel.function(:coalesce,
          Sequel.qualify(:dashboard_employees, :daily_checkup_updated_at),
          Sequel.qualify(:employees, :created_at)
        ).as(:daily_checkup_updated_at),
        Sequel.function(:coalesce,
          Sequel.qualify(:dashboard_employees, :daily_checkup_action),
          "Send Reminder"
        ).as(:daily_checkup_action),
        Sequel.function(:coalesce,
          Sequel.qualify(:dashboard_employees, :testing_status),
          "Not Registered"
        ).as(:testing_status),
        Sequel.function(:coalesce,
          Sequel.qualify(:dashboard_employees, :testing_updated_at),
          Sequel.qualify(:employees, :created_at)
        ).as(:testing_updated_at)
      )
    end
  end
end

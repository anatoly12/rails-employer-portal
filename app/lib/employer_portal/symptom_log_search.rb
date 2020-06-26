module EmployerPortal
  class SymptomLogSearch
    include Pagy::Backend

    # ~~ constants ~~
    DEFAULT_PAGE_SIZE = 5

    # ~~ accessors ~~
    attr_reader :employee, :results, :pagination

    # ~~ delegates ~~
    delegate :count, to: :pagination

    # ~~ public instance methods ~~
    def initialize(context, employee, params)
      @context = context
      @employee = employee
      @params = params
      if connected?
        @pagination, @results = pagy(sorted(dataset))
      else
        @pagination, @results = pagy_array([])
      end
    end

    def sort_order
      params[:order] || "log_date:desc"
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
      SymptomLog.where(account_id: employee.remote_id)
    end

    def sorted(ds)
      column, direction = sort_order.split(":")
      ds = ds.order(:log_date)
      direction=="desc" ? ds.reverse : ds
    end
  end
end

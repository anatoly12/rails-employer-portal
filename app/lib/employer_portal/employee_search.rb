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
      Employee.where employer_id: context.account_id
    end
  end
end

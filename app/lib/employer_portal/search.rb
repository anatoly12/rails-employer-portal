class EmployerPortal::Search
  include Pagy::Backend

  # ~~ constants ~~
  DEFAULT_PAGE_SIZE = 50

  # ~~ accessors ~~
  attr_reader :pagination, :results

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
    @pagination, results = pagy(dataset)
    @results = results.all
  end

  def filters
    @filters ||= ::EmployerPortal::Filters.new(
      context,
      params.fetch(:filters, {})
    )
  end

  def sort_order
    params[:order]
  end

  protected

  def query_class
    raise NotImplementedError, "#{self.class}#query_class"
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
    @query ||= query_class.new context
  end

  def dataset
    query.search_dataset filters.to_hash, sort_order
  end

end

class EmployerPortal::Search
  include Pagy::Backend

  # ~~ accessors ~~
  attr_reader :pagination

  # ~~ delegates ~~
  delegate :count, to: :pagination

  # ~~ public class methods ~~
  def self.from_params(context, params)
    new context, params.permit(:order, :page, filters: {})
  end

  # ~~ public instance methods ~~
  def initialize(context, params)
    @context = context
    @params = params
    @pagination, results = pagy(dataset)
    @raw_results = results.all
  end

  def results
    @results ||= raw_results.map do |result|
      decorator.new context, result
    end
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

  private

  attr_reader :context, :params, :raw_results

  # ~~ overrides for Pagy ~~
  def pagy_get_vars(collection, vars)
    {
      count: collection.count,
      page: params["page"],
      items: vars[:items] || default_page_size,
    }
  end

  # ~~ private instance methods ~~
  def default_page_size
    50
  end

  def query_class
    raise NotImplementedError, "#{self.class}#query_class"
  end

  def decorator
    raise NotImplementedError
  end

  def query
    @query ||= query_class.new context
  end

  def dataset
    query.search_dataset filters.to_hash, sort_order
  end
end

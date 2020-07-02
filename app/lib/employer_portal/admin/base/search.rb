class EmployerPortal::Admin::Base::Search
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
    @pagination, @results = pagy(sorted(filtered(dataset)))
  end

  def filters
    @filters ||= ::EmployerPortal::Admin::Filters.new(
      context,
      params.fetch(:filters, {})
    )
  end

  def sort_order
    params[:order] || "created_at:desc"
  end

  def results
    @results.all.map do |result|
      decorator.new context, result
    end
  end

  protected

  def decorator
    raise NotImplementedError
  end

  def dataset
    raise NotImplementedError
  end

  def apply_filter(ds, _key, _value)
    ds
  end

  def apply_order(ds, _column)
    ds
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
  def filtered(ds)
    params.fetch(:filters, {}).reject do |_, value|
      value.blank?
    end.each do |key, value|
      ds = apply_filter(ds, key, value)
    end
    ds
  end

  def sorted(ds)
    column, direction = sort_order.split(":")
    ds = apply_order(ds, column)
    direction == "desc" ? ds.reverse : ds
  end
end

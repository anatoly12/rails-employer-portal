class EmployerPortal::Query::Base
  def initialize(context)
    @context = context
  end

  def search_dataset(filters, sort_order)
    ds = dataset
    filters.each do |key, value|
      ds = apply_filter(ds, key, value)
    end
    column, direction = sort_order.split(":")
    ds = apply_order(ds, column)
    direction == "desc" ? ds.reverse : ds
  end

  private

  attr_reader :context

  def dataset
    raise NotImplementedError, "#{self.class}#dataset"
  end

  def value_for_ilike(string)
    "%#{escape_for_like(string)}%"
  end
end

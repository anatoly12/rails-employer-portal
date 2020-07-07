class EmployerPortal::Query::Base

  # ~~ public instance methods ~~
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

  # ~~ private instance methods ~~
  def dataset
    raise NotImplementedError, "#{self.class}#dataset"
  end

  def apply_filter(_ds, _key, _value)
    raise NotImplementedError, "#{self.class}#apply_filter"
  end

  def apply_order(_ds, _column)
    raise NotImplementedError, "#{self.class}#apply_order"
  end

  def value_for_ilike(string)
    "%#{string.gsub /([%_\\])/, "\\\\\\1"}%"
  end
end

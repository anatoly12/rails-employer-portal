class EmployerPortal::Query::EmployeeTag < EmployerPortal::Query::Base
  private

  # ~~ overrides for EmployerPortal::Query::Base ~~
  def dataset
    EmployeeTag.eager_graph(*graphs).set_graph_aliases(graph_aliases).where(
      company_id: context.company_id,
    ).group_by(:id).qualify.from_self.where(
      Sequel.identifier(:employee_count) > 0
    )
  end

  def apply_filter(ds, _key, _value)
    ds
  end

  def apply_order(ds, _column)
    ds.order Sequel.desc(:employee_count), :name
  end

  # ~~ private instance methods ~~
  def graphs
    [:taggings]
  end

  def graph_aliases
    {
      id: [:employee_tags, :id],
      name: [:employee_tags, :name],
      employee_count: [:employee_tags, :employee_count, Sequel.function(:count, Sequel.qualify(:taggings, :employee_id)).distinct],
    }
  end
end

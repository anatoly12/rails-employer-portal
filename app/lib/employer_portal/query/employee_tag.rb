class EmployerPortal::Query::EmployeeTag < EmployerPortal::Query::Base
  private

  # ~~ overrides for EmployerPortal::Query::Base ~~
  def dataset
    ds = EmployeeTag.eager_graph(*graphs).set_graph_aliases graph_aliases
    ds = ds.where company_id: context.company_id
    unless context.allowed_all_employee_tags?
      ds = ds.where id: context.allowed_employee_tags
    end
    ds.group_by(:id).qualify.from_self
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

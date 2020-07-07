class EmployerPortal::Query::Company < EmployerPortal::Query::Base
  private

  # ~~ overrides for EmployerPortal::Query::Base ~~
  def dataset
    Company.eager_graph(*graphs).set_graph_aliases(graph_aliases).where(
      deleted_at: nil,
    ).group_by(:id).qualify.from_self
  end

  def apply_filter(ds, key, value)
    case key
    when "plan_id_equals"
      ds.where plan_id: value.to_s
    when "name_contains"
      ds.where Sequel.ilike(:name, value_for_ilike(value))
    end || ds
  end

  def apply_order(ds, column)
    case column
    when "name"
      ds.order(:name)
    else # "created_at"
      ds.order(:created_at, :id)
    end
  end

  # ~~ private instance methods ~~
  def graphs
    [:plan, :undeleted_employers, :employees]
  end

  def graph_aliases
    {
      id: [:companies, :id],
      name: [:companies, :name],
      created_at: [:companies, :created_at],
      plan_id: [:plan, :id],
      plan_name: [:plan, :name],
      employer_count: [:companies, :employer_count, Sequel.function(:count, Sequel.qualify(:undeleted_employers, :id)).distinct],
      employee_count: [:companies, :employee_count, Sequel.function(:count, Sequel.qualify(:employees, :id)).distinct],
    }
  end
end

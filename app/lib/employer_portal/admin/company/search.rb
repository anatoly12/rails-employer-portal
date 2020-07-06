class EmployerPortal::Admin::Company::Search < ::EmployerPortal::Admin::Base::Search
  private

  # ~~ overrides for EmployerPortal::Admin::Base::Search ~~
  def decorator
    ::EmployerPortal::Admin::Company::Viewer
  end

  # ~~ overrides for EmployerPortal::Search ~~
  def dataset
    Company.
      where(deleted_at: nil).
      qualify.
      eager_graph(:plan, :employers, :employees).
      group_by(Sequel.qualify(:companies, :id)).
      set_graph_aliases(
      created_at: [:companies, :created_at],
      id: [:companies, :id],
      name: [:companies, :name],
      plan_id: [:plan, :id],
      plan_name: [:plan, :name],
      employer_count: [:companies, :employer_count, Sequel.function(:count, Sequel.qualify(:employers, :id)).distinct],
      employee_count: [:companies, :employee_count, Sequel.function(:count, Sequel.qualify(:employees, :id)).distinct],
    )
  end

  def apply_filter(ds, key, value)
    case key
    when "plan_id_equals"
      ds.where plan_id: value.to_s
    when "name_contains"
      ds.where Sequel.ilike(
        Sequel.qualify(:companies, :name),
        filters.value_for_ilike(value)
      )
    end || ds
  end

  def apply_order(ds, column)
    ds = case column
      when "name"
        ds.order(:name)
      when "created_at"
        ds.order(:created_at, :id)
      else
        ds
      end
  end
end

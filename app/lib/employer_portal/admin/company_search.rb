class EmployerPortal::Admin::CompanySearch < ::EmployerPortal::Admin::Search
  private

  # ~~ overrides for EmployerPortal::Admin::Search ~~
  def decorator
    ::EmployerPortal::Admin::CompanyForDashboard
  end

  def dataset
    Company.
      eager_graph(:employers, :employees).
      group_by(Sequel.qualify(:companies, :id)).
      set_graph_aliases(
      created_at: [:companies, :created_at],
      id: [:companies, :id],
      name: [:companies, :name],
      plan: [:companies, :plan],
      employer_count: [:companies, :employer_count, Sequel.function(:count, Sequel.qualify(:employers, :id)).distinct],
      employee_count: [:companies, :employee_count, Sequel.function(:count, Sequel.qualify(:employees, :id)).distinct],
    )
  end

  def apply_order(ds, column)
    ds = case column
      when "name"
        ds.order(:name)
      when "created_at"
        ds.order(:created_at)
      else
        ds
      end
  end
end

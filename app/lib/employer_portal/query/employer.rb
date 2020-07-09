class EmployerPortal::Query::Employer < EmployerPortal::Query::Base
  private

  # ~~ overrides for EmployerPortal::Query::Base ~~
  def dataset
    Employer.eager_graph(*graphs).set_graph_aliases(graph_aliases).where(
      deleted_at: nil,
      Sequel.qualify(:company, :deleted_at) => nil,
    ).qualify.from_self
  end

  def apply_filter(ds, key, value)
    case key
    when "company_id_equals"
      ds.where company_id: value.to_s
    when "full_name_contains"
      ds.where Sequel.ilike(Sequel.function(:concat, :first_name, " ", :last_name), value_for_ilike(value))
    when "email_contains"
      ds.where Sequel.ilike(:email, value_for_ilike(value))
    end || ds
  end

  def apply_order(ds, column)
    case column
    when "first_name"
      ds.order(:first_name)
    when "last_name"
      ds.order(:last_name)
    when "full_name"
      ds.order Sequel.function(:concat, :first_name, " ", :last_name)
    when "email"
      ds.order(:email)
    else # "created_at"
      ds.order(:created_at, :id)
    end
  end

  # ~~ private instance methods ~~
  def graphs
    if context.section_application?
      [{ company: :plan }]
    else
      [:company]
    end
  end

  def graph_aliases
    res = {
      id: [:employers, :id],
      uuid: [:employers, :uuid],
      email: [:employers, :email],
      first_name: [:employers, :first_name],
      last_name: [:employers, :last_name],
      password_digest: [:employers, :password_digest],
      role: [:employers, :role],
      created_at: [:employers, :created_at],
    }
    if context.section_application?
      res.merge!(
        company_id: [:company, :id],
        plan_id: [:plan, :id],
        daily_checkup_enabled: [:plan, :daily_checkup_enabled],
        testing_enabled: [:plan, :testing_enabled],
        health_passport_enabled: [:plan, :health_passport_enabled],
        employer_limit: [:plan, :employer_limit],
        employee_limit: [:plan, :employee_limit],
      )
    else
      res.merge!(
        company_id: [:company, :id],
        company_name: [:company, :name],
      )
    end
    res
  end
end

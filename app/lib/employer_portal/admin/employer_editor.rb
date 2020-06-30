class EmployerPortal::Admin::EmployerEditor < ::EmployerPortal::Admin::Editor

  # ~~ delegates ~~
  delegate :company_id, :first_name, :last_name, :email, :role, to: :edited

  # ~~ public instance methods ~~
  def full_name
    "#{first_name} #{last_name}".presence || email
  end

  def update_attributes(params)
    super params.fetch(:employer, {}).permit(
      :company_id,
      :role,
      :first_name,
      :last_name,
      :email,
      :password
    )
  end

  def companies_for_select
    Company.all.map do |company|
      [company.name, company.id]
    end
  end

  def roles_for_select
    [
      ["Super admin", "super_admin"],
      ["Admin", "admin"],
    ]
  end

  protected

  # ~~ overrides for EmployerPortal::Admin::Editor ~~
  def self.find_by_id!(id)
    Employer.where(
      id: id,
    ).limit(1).first || raise(::EmployerPortal::Error::Employer::NotFound)
  end

  def self.new_model
    Employer.new
  end
end

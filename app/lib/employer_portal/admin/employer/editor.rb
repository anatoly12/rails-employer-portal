class EmployerPortal::Admin::Employer::Editor < ::EmployerPortal::Admin::Base::Editor

  # ~~ delegates ~~
  delegate :company_id, :first_name, :last_name, :email, :role, to: :edited

  # ~~ public instance methods ~~
  def full_name
    "#{first_name} #{last_name}".presence || email
  end

  def update_attributes(params)
    edited.set params.fetch(:employer, {}).permit(
      :company_id,
      :role,
      :first_name,
      :last_name,
      :email,
      :password
    )
    insert_or_update
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

  # ~~ overrides for EmployerPortal::Admin::Base::Editor ~~
  def self.find_by_id!(uuid)
    Employer.where(
      uuid: uuid,
    ).limit(1).first || raise(::EmployerPortal::Error::Employer::NotFound)
  end

  def self.new_model
    Employer.new
  end

  private

  # ~~ private instance methods ~~
  def insert_or_update
    return false unless edited.valid?

    was_new = edited.new?
    existing = Employer.where(email: email).exclude(deleted_at: nil).first
    if existing
      existing.set(
        company_id: edited.company_id,
        role: role,
        first_name: first_name,
        last_name: last_name,
        password: edited.password,
        deleted_at: nil,
      )
      @edited = existing
    end
    edited.save validate: false
    EmailTriggerJob.perform_later(
      EmailTemplate::TRIGGER_EMPLOYER_NEW,
      edited.uuid,
      "password" => edited.password,
    ) if was_new
    true
  end
end

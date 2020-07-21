class EmployerPortal::Admin::Employer::Editor < ::EmployerPortal::Admin::Base::Editor

  # ~~ constants ~~
  EMPLOYEE_TAG_UNLIMITED = "unlimited"
  EMPLOYEE_TAG_RESTRICTED = "restricted"

  # ~~ delegates ~~
  delegate :company_id, :first_name, :last_name, :email, :role, :allowed_to_add_employees, :allowed_to_add_employee_tags, :allowed_employee_tags, to: :edited

  # ~~ public instance methods ~~
  def full_name
    "#{first_name} #{last_name}".presence || email
  end

  def update_attributes(params)
    employer_params = params.fetch :employer, {}
    edited.set employer_params.permit(
      :company_id,
      :role,
      :first_name,
      :last_name,
      :email,
      :password,
      :allowed_to_add_employees,
      :allowed_to_add_employee_tags,
    )
    edited.allowed_all_employee_tags = employer_params[:employee_tag_mode] == EMPLOYEE_TAG_UNLIMITED
    edited.allowed_employee_tags = employer_params.fetch(:allowed_employee_tags, []).map(&:to_i).reject(&:zero?)
    edited.allowed_to_add_employee_tags = false unless edited.allowed_all_employee_tags
    insert_or_update
  end

  def companies
    @companies ||= Company.all
  end

  def roles_for_select
    [
      ["Super admin", "super_admin"],
      ["Admin", "admin"],
    ]
  end

  def employee_tag_mode
    edited.allowed_all_employee_tags ? EMPLOYEE_TAG_UNLIMITED : EMPLOYEE_TAG_RESTRICTED
  end

  def employee_tag_modes_for_select
    [
      ["Access to ALL employee groups", EMPLOYEE_TAG_UNLIMITED],
      ["Access to specific employee groups only", EMPLOYEE_TAG_RESTRICTED],
    ]
  end

  def employee_tags
    EmployeeTag.order(:name).all
  end

  protected

  # ~~ overrides for EmployerPortal::Admin::Base::Editor ~~
  def self.find_by_id!(uuid)
    Employer.where(
      uuid: uuid,
    ).limit(1).first || raise(::EmployerPortal::Error::Employer::NotFound)
  end

  def self.new_model
    Employer.new(
      allowed_to_add_employees: true,
      allowed_to_add_employee_tags: true,
      allowed_all_employee_tags: true,
      allowed_employee_tags: [],
    )
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

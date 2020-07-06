class EmployerPortal::Admin::EmailTemplate::Editor < ::EmployerPortal::Admin::Base::Editor

  # ~~ delegates ~~
  delegate :name, :subject, :trigger_key, :plan_id, :from, :html, :text,
    :covid19_message_code, to: :edited

  # ~~ public instance methods ~~
  def update_attributes(params)
    super params.fetch(:email_template, {}).permit(
      :name,
      :subject,
      :trigger_key,
      :plan_id,
      :from,
      :covid19_message_code,
      :html,
      :text
    )
  end

  def trigger_keys_for_select
    [
      ["Admin user invites a new employer", EmailTemplate::TRIGGER_EMPLOYER_NEW],
      ["Employer password forgotten", EmailTemplate::TRIGGER_EMPLOYER_PASSWORD_FORGOTTEN],
      ["Employer invites a new employee", EmailTemplate::TRIGGER_EMPLOYEE_NEW],
      ["Contact employee when symptomatic", EmailTemplate::TRIGGER_EMPLOYEE_CONTACT],
      ["Remind employee to enter daily symptom checkup", EmailTemplate::TRIGGER_EMPLOYEE_REMINDER],
    ]
  end

  def plans_for_select
    plans = Plan.where(deleted_at: nil).all.map do |plan|
      [plan.name, plan.id]
    end
    plans.unshift(["All plans", nil])
    plans
  end

  def covid19_message_codes_for_select
    ::EmployerPortal::Sync::Covid19MessageCode.order(
      :message_code
    ).all.map do |message_code|
      [message_code.message_subject, message_code.message_code]
    end
  end

  protected

  # ~~ overrides for EmployerPortal::Admin::Base::Editor ~~
  def self.find_by_id!(id)
    EmailTemplate.where(
      id: id,
    ).limit(1).first || raise(::EmployerPortal::Error::EmailTemplate::NotFound)
  end

  def self.new_model
    EmailTemplate.new
  end
end

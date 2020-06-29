class EmployerPortal::Admin::EmailTemplateEditor < ::EmployerPortal::Admin::Editor

  # ~~ delegates ~~
  delegate :name, :trigger_key, :from, :subject, :html, :text, :covid19_message_code, to: :edited

  # ~~ public instance methods ~~
  def update_attributes(params)
    super params.fetch(:email_template, {}).permit(
      :name,
      :trigger_key,
      :from,
      :subject,
      :covid19_message_code,
      :html,
      :text
    )
  end

  def trigger_keys_for_select
    [
      ["Contact (when employee is symptomatic)", "contact"],
      ["Invite (for newly added employee)", "invite"],
      ["Password forgotten (for employer accounts)", "password_forgotten"],
      ["Reminder (tell employee to enter daily symptom checkup)", "reminder"],
    ]
  end

  def covid19_message_codes_for_select
    ::EmployerPortal::Sync::Covid19MessageCode.order(
      :message_code
    ).all.map do |message_code|
      [message_code.message_subject, message_code.message_code]
    end
  end

  protected

  # ~~ overrides for EmployerPortal::Admin::Editor ~~
  def self.find_by_id!(id)
    EmailTemplate.where(
      id: id,
    ).limit(1).first || raise(::EmployerPortal::Error::EmailTemplate::NotFound)
  end

  def self.new_model
    EmailTemplate.new
  end
end

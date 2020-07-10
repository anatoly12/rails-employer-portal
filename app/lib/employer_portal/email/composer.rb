class EmployerPortal::Email::Composer

  # ~~ public instance methods ~~
  def initialize(context, email_template, recipient, opts)
    @context = context
    @email_template = email_template
    @recipient = recipient
    @opts = opts
  end

  def subject
    apply_replacements email_template.subject
  end

  def html
    apply_replacements email_template.html
  end

  def text
    apply_replacements email_template.text
  end

  def deliver_email
    TriggerMailer.email(
      from: email_template.from,
      to: recipient.email,
      subject: subject,
      html: html,
      text: text,
    ).deliver_now
  end

  def create_covid_message
    return unless email_template.covid19_message_code
    return unless context.sync_connected?
    return unless employee&.remote_id

    ::EmployerPortal::Sync::Covid19Message.create(
      account_id: employee.remote_id,
      message_code: email_template.covid19_message_code,
    )
  end

  def create_email_log
    EmailLog.create(
      email_template: email_template,
      company: recipient.company,
      employer: employer,
      employee: employee,
      trigger_key: email_template.trigger_key,
      from: email_template.from,
      recipient: recipient.email,
      subject: subject,
      html: html,
      text: text,
    )
  end

  private

  attr_reader :context, :email_template, :recipient, :opts

  def employer
    employee&.employer || recipient
  end

  def employee
    recipient if recipient.kind_of? Employee
  end

  def dashboard_employee
    employee.dashboard_employee if employee && context.sync_connected?
  end

  def employee_full_name
    return unless employee

    dashboard_employee&.full_name || "#{employee.first_name} #{employee.last_name}"
  end

  def employee_password
    opts["password"] if recipient.kind_of? Employee
  end

  def employee_reset_password_token
    opts["reset_password_token"] if recipient.kind_of? Employee
  end

  def employer_password
    opts["password"] if recipient.kind_of? Employer
  end

  def employer_reset_password_token
    opts["reset_password_token"] if recipient.kind_of? Employer
  end

  def replacements
    {
      "daily_checkup_status" => dashboard_employee&.daily_checkup_status,
      "employee_email" => employee&.email,
      "employee_full_name" => employee_full_name,
      "employee_password" => employee_password,
      "employee_reset_password_token" => employee_reset_password_token,
      "employer_email" => employer&.email,
      "employer_first_name" => employer&.first_name,
      "employer_last_name" => employer&.last_name,
      "employer_password" => employer_password,
      "employer_reset_password_token" => employer_reset_password_token,
    }
  end

  def apply_replacements(string)
    return unless string.present?

    replacements.each do |key, value|
      string.gsub! "{{#{key}}}", value.to_s
    end
    string
  end
end

class EmployerPortal::Email::Trigger

  # ~~ public instance methods ~~
  def initialize(context, trigger_key, recipient_id, opts)
    @context = context
    @trigger_key = trigger_key
    @recipient_id = recipient_id
    @opts = opts
  end

  def send_all
    email_templates.flat_map do |email_template|
      composer = ::EmployerPortal::Email::Composer.new context, email_template, recipient, opts
      composer.deliver_email
      composer.create_covid_message
      composer.create_email_log
    end
  end

  private

  attr_reader :context, :trigger_key, :recipient_id, :opts

  # ~~ private instance methods ~~
  def recipient
    @recipient = if trigger_key.starts_with? "employer_"
        find_employer_by_id!
      elsif trigger_key.starts_with? "employee_"
        find_employee_by_id!
      else
        raise ::EmployerPortal::Error::Email::InvalidTrigger, "doesn't know how to find recipient for #{trigger_key}"
      end
  end

  def find_employer_by_id!
    Employer.where(id: recipient_id).eager(
      :company
    ).first || raise(::EmployerPortal::Error::Employer::NotFound)
  end

  def find_employee_by_id!
    Employee.where(id: recipient_id).eager(
      :company, :employer
    ).first || raise(::EmployerPortal::Error::Employee::NotFound)
  end

  def email_templates
    @email_templates ||= EmailTemplate.where(
      trigger_key: trigger_key,
      deleted_at: nil,
    ).where(
      Sequel.|({ plan_id: nil }, { plan_id: recipient.company.plan_id })
    ).order(:id).all
  end
end

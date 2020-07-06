class EmployerPortal::Employee::Editor

  # ~~ delegates ~~
  delegate :first_name, :last_name, :email, :phone, :state, :to_key,
    :to_model, :to_param, to: :edited

  # ~~ public class methods ~~
  def self.from_params(context, params)
    edited = if params[:id].present?
        Employee.where(
          company_id: context.company_id,
          uuid: params[:id],
        ).limit(1).first || raise(::EmployerPortal::Error::Employee::NotFound)
      else
        Employee.new(
          company_id: context.company_id,
          employer_id: context.account_id,
        )
      end
    new context, edited, params.permit(:filters, :order, :page)
  end

  # ~~ public instance methods ~~
  def initialize(context, edited, symptom_log_params = {})
    @context = context
    @edited = edited
    @symptom_log_params = symptom_log_params
  end

  def persisted?
    !edited.new?
  end

  def errors_on(column)
    edited.errors.on(column)
  end

  def update_attributes(params)
    edited.set params.fetch(:employee, {}).permit(
      :first_name,
      :last_name,
      :email,
      :phone,
      :state
    )
    success = edited.save raise_on_failure: false
    CreateAccountForEmployeeJob.perform_later edited.uuid if success
    success
  end

  def symptom_log_search
    @symptom_log_search ||= ::EmployerPortal::SymptomLog::Search.new context, edited, symptom_log_params
  end

  def health_passport
    @health_passport ||= ::EmployerPortal::HealthPassport.new context, edited, dashboard_employee
  end

  def daily_checkup_need_contact?
    daily_checkup_action == "Contact"
  end

  def already_contacted?
    sent_at = last_trigger_by_key[EmailTemplate::TRIGGER_EMPLOYEE_CONTACT]
    sent_at && sent_at > 1.day.ago
  end

  def last_contacted_at
    sent_at = last_trigger_by_key[EmailTemplate::TRIGGER_EMPLOYEE_CONTACT]
    sent_at.strftime("%F %R UTC") if sent_at
  end

  def contact!
    EmailTriggerJob.perform_later(
      EmailTemplate::TRIGGER_EMPLOYEE_CONTACT,
      edited.uuid
    )
  end

  def daily_checkup_need_reminder?
    daily_checkup_action == "Send Reminder"
  end

  def already_sent_reminder?
    sent_at = last_trigger_by_key[EmailTemplate::TRIGGER_EMPLOYEE_REMINDER]
    sent_at && sent_at > 1.day.ago
  end

  def last_sent_reminder_at
    sent_at = last_trigger_by_key[EmailTemplate::TRIGGER_EMPLOYEE_REMINDER]
    sent_at.strftime("%F %R UTC") if sent_at
  end

  def send_reminder!
    EmailTriggerJob.perform_later(
      EmailTemplate::TRIGGER_EMPLOYEE_REMINDER,
      edited.uuid
    )
  end

  def synced?
    persisted? && edited.remote_id && context.sync_connected?
  end

  def active?
    dashboard_employee&.is_active==1
  end

  def deactivate!
    ::EmployerPortal::Sync::Account.where(
      id: edited.remote_id
    ).update is_active: false
  end

  def reactivate!
    ::EmployerPortal::Sync::Account.where(
      id: edited.remote_id
    ).update is_active: true
  end

  private

  attr_reader :context, :edited, :symptom_log_params

  # ~~ private instance methods ~~
  def dashboard_employee
    edited.dashboard_employee if synced?
  end

  def testing_status
    dashboard_employee&.testing_status || "Not Registered"
  end

  def daily_checkup_action
    dashboard_employee&.daily_checkup_action || "Send Reminder"
  end

  def last_trigger_by_key
    return {} unless persisted?

    @last_trigger_by_key ||= EmailLog.where(
      employee_id: edited.id,
    ).group_by(:trigger_key).select(
      :trigger_key,
      Sequel.function(:max, :created_at).as(:max)
    ).to_hash :trigger_key, :max
  end
end

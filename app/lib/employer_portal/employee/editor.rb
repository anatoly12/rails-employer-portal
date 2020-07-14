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

  def contact_needed?
    dashboard_employee&.daily_checkup_status == "Not Cleared"
  end

  def contact_queued?
    edited.contact_queued_at && edited.contact_queued_at.to_date == Date.today
  end

  def contact_queued_at
    edited.contact_queued_at.strftime("%F %R UTC") if edited.contact_queued_at
  end

  def contact_queue!(now = Time.now)
    Sequel::Model.db.transaction do
      EmailTriggerJob.perform_later(
        EmailTemplate::TRIGGER_EMPLOYEE_CONTACT,
        edited.uuid
      )
      edited.update contact_queued_at: now
    end
  end

  def reminder_needed?
    dashboard_employee&.daily_checkup_status == "Did Not Submit"
  end

  def reminder_queued?
    edited.reminder_queued_at && edited.reminder_queued_at.to_date == Date.today
  end

  def reminder_queued_at
    edited.reminder_queued_at.strftime("%F %R UTC") if edited.reminder_queued_at
  end

  def reminder_queue!(now = Time.now)
    Sequel::Model.db.transaction do
      EmailTriggerJob.perform_later(
        EmailTemplate::TRIGGER_EMPLOYEE_REMINDER,
        edited.uuid
      )
      edited.update reminder_queued_at: now
    end
  end

  def synced?
    persisted? && edited.remote_id && context.sync_connected?
  end

  def active?
    dashboard_employee&.is_active == 1
  end

  def deactivate!
    ::EmployerPortal::Sync::Account.where(
      id: edited.remote_id,
    ).update is_active: false
  end

  def reactivate!
    ::EmployerPortal::Sync::Account.where(
      id: edited.remote_id,
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
end

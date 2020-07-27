class EmployerPortal::Employee::Editor

  # ~~ delegates ~~
  delegate :first_name, :last_name, :email, :phone, :state, :to_key, :to_model, :to_param, to: :edited
  delegate :selfie_url, :initials, to: :viewer
  delegate :whitelist, to: :employee_tag, prefix: :tags

  # ~~ public class methods ~~
  def self.from_params(context, params)
    edited = if params[:id].present?
        Employee.where(
          company_id: context.company_id,
          uuid: params[:id],
        ).limit(1).eager(
          :taggings,
          :tags
        ).first || raise(::EmployerPortal::Error::Employee::NotFound)
      else
        Employee.new(
          company_id: context.company_id,
          employer_id: context.account_id,
        )
      end
    new context, edited, params.permit(:order, :page, filters: {})
  end

  # ~~ public instance methods ~~
  def initialize(context, edited, symptom_log_params = {})
    @context = context
    @edited = edited
    edited.track_tags_changes
    @symptom_log_params = symptom_log_params
  end

  def persisted?
    !edited.new?
  end

  def errors_on(column)
    edited.errors.on(column)
  end

  def update_attributes(params)
    employee_params = params.fetch :employee, {}
    edited.set employee_params.permit(
      :first_name,
      :last_name,
      :email,
      :phone,
      :state
    )
    return false unless edited.valid?

    @tags = if employee_params[:tags].present?
        JSON.parse(employee_params[:tags]).map { |tag| tag["value"] }
      else
        []
      end
    persist
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

  def tags
    @tags ||= edited.tags_before.select do |tag|
      context.allowed_all_employee_tags? || context.allowed_employee_tags.include?(tag.id)
    end.map(&:name).join ","
  end

  def ensure_access!
    allowed = if persisted?
        context.allowed_all_employee_tags? || (edited.tags_before.map(&:id) & context.allowed_employee_tags).any?
      else
        context.allowed_to_add_employees?
      end
    raise ::EmployerPortal::Error::Employee::NotAllowed unless allowed
  end

  private

  attr_reader :context, :edited, :symptom_log_params

  # ~~ private instance methods ~~
  def dashboard_employee
    edited.dashboard_employee if synced?
  end

  def persist
    Sequel::Model.db.transaction do
      persist_tags
      persist_employees
      persist_taggings
      persist_audit
    end
  end

  def employee_tag
    @employee_tag ||= ::EmployerPortal::EmployeeTag.new context
  end

  def persist_tags
    edited.tags_after = employee_tag.find_or_create_tags edited.tags_before, tags
  end

  def persist_employees
    edited.save validate: false
  end

  def persist_taggings
    to_add = edited.tags_after.dup
    edited.taggings.each do |tagging|
      if to_add.include? tagging.tag
        to_add.delete tagging.tag
      else
        tagging.destroy
      end
    end
    to_add.each do |tag|
      edited.add_tagging EmployeeTagging.new(tag: tag)
    end
  end

  def persist_audit
    CreateAccountForEmployeeJob.perform_later edited.uuid
  end

  def viewer
    @viewer ||= ::EmployerPortal::Employee::Viewer.new context, edited
  end
end

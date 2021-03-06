class EmployerPortal::Employee::Viewer

  # ~~ delegates ~~
  delegate :to_param, :first_name, :last_name, :state, :remote_id, to: :decorated

  # ~~ public instance methods ~~
  def initialize(context, decorated)
    @context = context
    @decorated = decorated
  end

  def flagged?
    daily_checkup_status == "Not Cleared" || testing_status == "Inconclusive"
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def daily_checkup_status
    return "Deactivated" unless active?

    dashboard_employee&.daily_checkup_status || "Did Not Submit"
  end

  def daily_checkup_updated_at
    updated_at = dashboard_employee&.daily_checkup_updated_at
    updated_at ? updated_at.strftime("%F") : "Never"
  end

  def contact_needed?
    active? && dashboard_employee&.daily_checkup_status == "Not Cleared"
  end

  def contact_queued?
    decorated.contact_queued_at && decorated.contact_queued_at.to_date == Date.today
  end

  def reminder_needed?
    active? && dashboard_employee&.daily_checkup_status == "Did Not Submit"
  end

  def reminder_queued?
    decorated.reminder_queued_at && decorated.reminder_queued_at.to_date == Date.today
  end

  def testing_status
    return "Deactivated" unless active?

    dashboard_employee&.testing_status || "Not Registered"
  end

  def testing_updated_at
    updated_at = dashboard_employee&.testing_updated_at
    updated_at ? updated_at.strftime("%F") : "Never"
  end

  def selfie_url
    ::EmployerPortal::Aws.presigned_url dashboard_employee&.selfie_s3_key
  end

  def initials
    full_name.split(" ").map(&:chr).first(2).join.upcase
  end

  def active?
    !synced? || dashboard_employee&.is_active == 1
  end

  private

  attr_reader :context, :decorated

  # ~~ private instance methods ~~
  def synced?
    remote_id && context.sync_connected?
  end

  def dashboard_employee
    decorated.dashboard_employee if synced?
  end
end

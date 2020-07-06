class EmployerPortal::Employee::Viewer

  # ~~ delegates ~~
  delegate :to_param, :first_name, :last_name, :state, :remote_id, to: :employee

  # ~~ public instance methods ~~
  def initialize(context, employee, last_contacted_at, last_reminded_at)
    @context = context
    @employee = employee
    @last_contacted_at = last_contacted_at
    @last_reminded_at = last_reminded_at
  end

  def flagged?
    daily_checkup_status == "Not Cleared" || testing_status == "Inconclusive"
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def daily_checkup_status
    return unless context.sync_connected?

    dashboard_employee&.daily_checkup_status
  end

  def daily_checkup_updated_at
    updated_at = dashboard_employee&.daily_checkup_updated_at
    updated_at ? updated_at.strftime("%F") : "Never"
  end

  def daily_checkup_need_contact?
    return false unless synced?

    daily_checkup_action == "Contact"
  end

  def already_contacted?
    last_contacted_at && last_contacted_at > 1.day.ago
  end

  def daily_checkup_need_reminder?
    return false unless synced?

    daily_checkup_action == "Send Reminder"
  end

  def already_sent_reminder?
    last_reminded_at && last_reminded_at > 1.day.ago
  end

  def testing_status
    dashboard_employee&.testing_status
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

  private

  attr_reader :context, :employee, :last_contacted_at, :last_reminded_at

  # ~~ private instance methods ~~
  def synced?
    remote_id && context.sync_connected?
  end

  def dashboard_employee
    employee.dashboard_employee if synced?
  end

  def daily_checkup_action
    dashboard_employee&.daily_checkup_action
  end
end

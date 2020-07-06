class EmployerPortal::Employee::Viewer

  # ~~ delegates ~~

  # ~~ public instance methods ~~
  def initialize(context, values, last_contacted_at, last_reminded_at)
    @context = context
    @values = values
    @last_contacted_at = last_contacted_at
    @last_reminded_at = last_reminded_at
  end

  def to_param
    values[:uuid]
  end

  def flagged?
    daily_checkup_status == "Not Cleared" || testing_status == "Inconclusive"
  end

  def full_name
    values[:full_name]
  end

  def state
    values[:state]
  end

  def daily_checkup_status
    values[:daily_checkup_status]
  end

  def daily_checkup_updated_at
    updated_at = values[:daily_checkup_updated_at]
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
    values[:testing_status]
  end

  def testing_updated_at
    updated_at = values[:testing_updated_at]
    updated_at ? updated_at.strftime("%F") : "Never"
  end

  def selfie_url
    ::EmployerPortal::Aws.presigned_url values[:selfie_s3_key]
  end

  def initials
    full_name.split(" ").map(&:chr).first(2).join.upcase
  end

  private

  attr_reader :context, :values, :last_contacted_at, :last_reminded_at

  def synced?
    values[:remote_id] && context.sync_connected?
  end

  def daily_checkup_action
    values[:daily_checkup_action]
  end
end

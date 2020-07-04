class EmailTriggerJob < ApplicationJob
  queue_as :default

  def perform(trigger_key, recipient_id, opts = {})
    trigger = ::EmployerPortal::Email::Trigger.new context, trigger_key, recipient_id, opts
    email_logs = trigger.send_all
    log "Email trigger #{trigger_key}: #{email_logs.size} email(s) sent"
  end

  private

  def context
    @context ||= ::EmployerPortal::Context.new(
      account_id: nil,
      section: :background_job,
    )
  end

  def log(message)
    Delayed::Worker.logger.info message
  end
end

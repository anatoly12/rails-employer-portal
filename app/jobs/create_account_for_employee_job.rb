class CreateAccountForEmployeeJob < ApplicationJob
  queue_as :default

  retry_on ::EmployerPortal::Error::Sync::Base, wait: :exponentially_longer, attempts: 3

  def perform(uuid)
    employee = Employee.where(uuid: uuid).limit(1).first
    if employee.nil?
      log "can't find employee #{uuid}"
    elsif employee.remote_id.present?
      log "employee #{uuid} is already linked to account #{employee.remote_id}"
    else
      ::EmployerPortal::Sync.create_account_for_employee!(employee)
      log "employee #{uuid} is now linked to account #{employee.remote_id}"
    end
  end

  private

  def log(message)
    Delayed::Worker.logger.info message
  end
end

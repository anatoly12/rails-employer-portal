class CreatePartnerForCompanyJob < ApplicationJob
  queue_as :default

  retry_on ::EmployerPortal::Error::Sync::Base, wait: :exponentially_longer, attempts: 3

  def perform(uuid)
    company = Company.where(uuid: uuid).limit(1).first
    if company.nil?
      log "can't find company #{uuid}"
    elsif company.remote_id.present?
      log "company #{uuid} is already linked to partner #{company.remote_id}"
    else
      ::EmployerPortal::Sync.create_partner_for_company! company
      log "company #{uuid} is now linked to partner #{company.remote_id}"
    end
  end

  private

  def log(message)
    Delayed::Worker.logger.info message
  end
end

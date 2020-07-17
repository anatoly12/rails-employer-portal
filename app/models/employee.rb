require "uri"

class Employee < Sequel::Model

  # ~~ plugins ~~
  plugin :uuid
  plugin :timestamps, update_on_create: true
  plugin :validation_helpers
  plugin :active_model
  plugin :with_audits

  # ~~ validations ~~
  def validate
    super
    validates_presence [:first_name, :last_name, :email, :phone]
    validates_format ::EmployerPortal::Regexp::EMAIL_FORMAT, :email, allow_blank: true
    validates_unique(:email) { |ds| ds.where(company_id: company_id) }
    if zipcode.present?
      validate_zipcode
    else
      validates_presence :state
      validates_includes UsaState.state_codes, :state, allow_blank: true, message: "must be a valid state code"
    end
  end

  # ~~ associations ~~
  many_to_one :company, class: "Company"
  many_to_one :employer, class: "Employer"
  one_to_many :email_logs, class: "EmailLog"
  one_to_many :contact_email_logs, class: "EmailLog", conditions: { trigger_key: EmailTemplate::TRIGGER_EMPLOYEE_CONTACT }
  one_to_many :reminder_email_logs, class: "EmailLog", conditions: { trigger_key: EmailTemplate::TRIGGER_EMPLOYEE_REMINDER }
  one_to_many :taggings, class: "EmployeeTagging"
  many_to_many :tags, through: :taggings

  # ~~ public class methods ~~
  def self.add_connected_associations
    many_to_one :dashboard_employee, class: "DashboardEmployee", key: :remote_id, primary_key: :id
  end

  def self.remove_connected_associations
    association_module.remove_method :dashboard_employee
  end

  # ~~ public instance methods ~~
  def to_param
    uuid
  end

  private

  # ~~ private instance methods ~~
  def validate_zipcode
    zip = ZipCode[zipcode]
    if zip
      set state: zip.state
    else
      errors.add(:zipcode, "must be a valid ZIP Code")
    end
  end
end

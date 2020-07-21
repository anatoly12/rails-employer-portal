require "uri"

class Employee < Sequel::Model

  # ~~ accessors ~~
  attr_accessor :tags_before, :tags_after

  # ~~ plugins ~~
  plugin :uuid
  plugin :timestamps, update_on_create: true
  plugin :validation_helpers
  plugin :active_model
  plugin :with_audits
  plugin :after_initialize

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
  many_to_many :tags, class: "EmployeeTag", join_table: :employee_taggings, right_key: :employee_tag_id

  # ~~ public class methods ~~
  def self.add_connected_associations
    many_to_one :dashboard_employee, class: "DashboardEmployee", key: :remote_id, primary_key: :id
  end

  def self.remove_connected_associations
    association_module.remove_method :dashboard_employee
  end

  # ~~ public instance methods ~~
  def after_initialize
    @tags_before = []
    @tags_after = []
  end

  def to_param
    uuid
  end

  def track_tags_changes
    @tags_before = tags.dup
    @tags_after = tags.dup
  end

  def previous_changes
    return super if tags_before == tags_after
    tag_names_before = tags_before.map(&:name).sort.join ","
    tag_names_after = tags_after.map(&:name).sort.join ","

    super.merge tags: [tag_names_before, tag_names_after]
  end

  def values
    return super unless tags_after

    super.merge tags: tags_after.map(&:name).sort.join(",")
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

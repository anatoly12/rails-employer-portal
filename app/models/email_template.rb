class EmailTemplate < Sequel::Model

  # ~~ constants ~~
  TRIGGER_EMPLOYER_NEW = "employer_new"
  TRIGGER_EMPLOYER_PASSWORD_FORGOTTEN = "employer_password_forgotten"
  TRIGGER_EMPLOYEE_NEW = "employee_new"
  TRIGGER_EMPLOYEE_CONTACT = "employee_contact"
  TRIGGER_EMPLOYEE_REMINDER = "employee_reminder"
  TRIGGER_KEYS = [
    TRIGGER_EMPLOYER_NEW,
    TRIGGER_EMPLOYER_PASSWORD_FORGOTTEN,
    TRIGGER_EMPLOYEE_NEW,
    TRIGGER_EMPLOYEE_CONTACT,
    TRIGGER_EMPLOYEE_REMINDER,
  ].freeze

  # ~~ plugins ~~
  plugin :timestamps, update_on_create: true
  plugin :validation_helpers
  plugin :active_model
  plugin :with_audits

  # ~~ validations ~~
  def validate
    super
    validates_presence [:name, :trigger_key, :from, :subject]
    validates_includes TRIGGER_KEYS, :trigger_key, allow_blank: true, message: "must be a valid trigger"
    validates_integer :covid19_message_code, allow_blank: true
  end

  # ~~ associations ~~
  many_to_one :plan, class: "Plan"
end

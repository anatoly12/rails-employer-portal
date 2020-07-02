class EmailTemplate < Sequel::Model
  # ~~ constants ~~
  TRIGGER_KEYS = [
    "employer_new",
    "employer_password_forgotten",
    "employee_new",
    "employee_contact",
    "employee_reminder",
  ].freeze

  # ~~ plugins ~~
  plugin :timestamps, update_on_create: true
  plugin :validation_helpers
  plugin :active_model

  # ~~ validations ~~
  def validate
    super
    validates_presence [:name, :trigger_key, :from, :subject]
    validates_includes TRIGGER_KEYS, :trigger_key, allow_blank: true, message: "must be a valid trigger"
  end

  # ~~ associations ~~
  many_to_one :plan, class: "Plan"
end

class EmailTemplate < Sequel::Model
  # ~~ constants ~~
  TRIGGER_KEYS = [
    "invite",
    "contact",
    "reminder",
    "password_forgotten"
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
end

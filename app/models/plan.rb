class Plan < Sequel::Model
  # ~~ plugins ~~
  plugin :uuid
  plugin :timestamps, update_on_create: true
  plugin :validation_helpers
  plugin :active_model

  # ~~ validations ~~
  def validate
    super
    validates_presence [:name]
    errors.add(:health_passport_enabled, "requires testing to be enabled") if health_passport_enabled && !testing_enabled
    validates_integer [:employer_limit, :employee_limit]
    validates_integer :remote_id, allow_blank: true
  end

  # ~~ associations ~~
  one_to_many :companies, class: "Company"
  one_to_many :undeleted_companies, class: "Company", conditions: {
    deleted_at: nil
  }
  one_to_many :email_templates, class: "EmailTemplate"
  one_to_many :undeleted_email_templates, class: "EmailTemplate", conditions: {
    deleted_at: nil
  }
end

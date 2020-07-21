class Employer < Sequel::Model
  include ActiveModel::SecurePassword

  # ~~ plugins ~~
  plugin :uuid
  plugin :timestamps, update_on_create: true
  plugin :secure_password, include_validations: false
  plugin :validation_helpers
  plugin :active_model
  plugin :with_audits
  plugin :serialization, :json, :allowed_employee_tags

  # ~~ validations ~~
  def validate
    super
    validates_presence [:company_id, :email, :role, :first_name, :last_name]
    validates_presence :password if new?
    validates_min_length 6, :password, allow_blank: true, message: lambda { |s| "is too short (min is #{s} characters)" }
    validates_max_length 128, :password, allow_blank: true, message: lambda { |s| "is too long (max is #{s} characters)" }
    validates_format ::EmployerPortal::Regexp::EMAIL_FORMAT, :email, allow_blank: true
    validates_unique(:email) { |ds| ds.where deleted_at: nil }
    validates_presence :allowed_employee_tags unless allowed_all_employee_tags
  end

  # ~~ associations ~~
  many_to_one :company, class: "Company"

  # ~~ public instance methods ~~
  def to_param
    uuid
  end
end

class Employer < Sequel::Model
  include ActiveModel::SecurePassword

  # ~~ plugins ~~
  plugin :uuid
  plugin :timestamps, update_on_create: true
  plugin :secure_password, include_validations: false
  plugin :validation_helpers
  plugin :active_model

  # ~~ validations ~~
  def validate
    super
    validates_presence [:company_id, :email, :role, :first_name, :last_name]
    validates_presence :password if new?
    validates_format ::EmployerPortal::Regexp::EMAIL_FORMAT, :email, allow_blank: true
    validates_unique(:email) { |ds| ds.where(company_id: company_id, deleted_at: nil) }
  end

  # ~~ associations ~~
  many_to_one :company, class: "Company"

  # ~~ public instance methods ~~
  def to_param
    uuid
  end
end

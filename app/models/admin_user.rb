class AdminUser < Sequel::Model
  include ActiveModel::SecurePassword

  # ~~ plugins ~~
  plugin :timestamps, update_on_create: true
  plugin :secure_password, include_validations: false
  plugin :validation_helpers
  plugin :active_model
  plugin :with_audits

  # ~~ validations ~~
  def validate
    super
    validates_presence :email
    validates_presence :password if new?
    validates_format ::EmployerPortal::Regexp::EMAIL_FORMAT, :email, allow_blank: true
    validates_unique(:email)
  end
end

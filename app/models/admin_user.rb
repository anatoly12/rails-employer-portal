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
    validates_min_length 6, :password, allow_blank: true, message: lambda { |s| "is too short (min is #{s} characters)" }
    validates_max_length 128, :password, allow_blank: true, message: lambda { |s| "is too long (max is #{s} characters)" }
    validates_format ::EmployerPortal::Regexp::EMAIL_FORMAT, :email, allow_blank: true
    validates_unique :email
  end
end

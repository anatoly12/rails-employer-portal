class Employer < Sequel::Model
  include ActiveModel::SecurePassword

  # ~~ plugins ~~
  plugin :uuid
  plugin :timestamps, update_on_create: true
  plugin :secure_password, include_validations: false
  plugin :validation_helpers

  # ~~ validations ~~
  def validate
    super
    validates_presence [:email, :role]
    validates_format EmployerPortal::Regexp::EMAIL_FORMAT, :email, allow_blank: true
    validates_unique(:email) { |ds| ds.where(company_id: company_id) }
  end

  # ~~ associations ~~
  many_to_one :company, class: "Company"
end

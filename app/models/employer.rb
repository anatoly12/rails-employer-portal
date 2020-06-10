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
    validates_format /\A[^@\s]+@[^@\s]+\z/, :email
    validates_unique [:company_id, :email], message: Sequel.lit("email is already taken")
  end

  # ~~ associations ~~
  many_to_one :company, class: "Company"

end

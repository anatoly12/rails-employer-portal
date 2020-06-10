class Employer < Sequel::Model
  include ActiveModel::SecurePassword

  # ~~ validations ~~
  has_secure_password

  # ~~ plugins ~~
  plugin :uuid
  plugin :timestamps

  # ~~ associations ~~
  many_to_one :company, class: "Company"

end

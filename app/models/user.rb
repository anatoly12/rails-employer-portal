class User < Sequel::Model
  include ActiveModel::SecurePassword
  has_secure_password
end

class Session
  include ActiveModel::Model

  attr_accessor :return_path, :username, :password

  validates :username, presence: true
  validates :password, presence: true
end

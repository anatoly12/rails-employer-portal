class Session
  include ActiveModel::Model

  attr_accessor :return_path, :username, :password
  delegate :id, to: :account, prefix: :account

  validates :username, presence: true
  validates :password, presence: true
  validate :password_matches_username

private

  def account
    @account ||= User.where(email: username).limit(1).first
  end

  def password_matches_username
    return if account.try(:authenticate, password)

    errors.add(:base, "Invalid username or password")
  end
end

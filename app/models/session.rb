class Session
  include ActiveModel::Model

  # ~~ virtual attributes ~~
  attr_accessor :return_path, :username, :password

  # ~~ delegates ~~
  delegate :id, to: :account, prefix: :account

  # ~~ validations ~~
  validates :username, presence: true
  validates :password, presence: true
  validate :password_matches_username

  private

  # ~~ private instance methods ~~
  def account
    @account ||= Employer.where(email: username).limit(1).first
  end

  def password_matches_username
    return if username.blank? || password.blank?
    return if account.try(:authenticate, password)

    errors.add(:base, "Invalid username or password")
  end
end

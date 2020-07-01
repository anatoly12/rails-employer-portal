module EmployerPortal
  class SessionEditor
    include ActiveModel::Model

    # ~~ virtual attributes ~~
    attr_accessor :return_path, :username, :password

    # ~~ delegates ~~
    delegate :id, to: :account, prefix: :account

    # ~~ validations ~~
    validates :username, presence: true
    validates :password, presence: true
    validate :password_matches_username

    # ~~ public instance methods ~~
    def errors_on(column)
      errors[column].presence
    end

    private

    # ~~ private instance methods ~~
    def account
      @account ||= Employer.where(
        email: username,
        deleted_at: nil,
      ).qualify.eager_graph(:company).where(
        Sequel.qualify(:company, :deleted_at) => nil,
      ).limit(1).all.first
    end

    def password_matches_username
      return if username.blank? || password.blank?
      return if account.try(:authenticate, password)

      errors.add(:base, "Invalid username or password")
    end
  end
end

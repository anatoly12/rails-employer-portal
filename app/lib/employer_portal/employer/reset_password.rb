class EmployerPortal::Employer::ResetPassword
  include ActiveModel::Model

  # ~~ accessors ~~
  attr_accessor :email, :password

  # ~~ delegates ~~
  delegate :id, to: :employer, prefix: :account

  # ~~ validations ~~
  validates :email, presence: true, format: { with: ::EmployerPortal::Regexp::EMAIL_FORMAT, allow_blank: true }

  # ~~ constants ~~
  RESET_PASSWORD_WITHIN = 7.days

  # ~~ public instance methods ~~
  def initialize(attributes)
    self.email = attributes[:email]
    self.password = attributes[:password]
  end

  def errors_on(column)
    if employer
      employer.errors.on(column)
    else
      errors[column].presence
    end
  end

  def trigger!
    Sequel::Model.db.transaction do
      return false unless employer

      reset_password_token = SecureRandom.urlsafe_base64(15).tr "lIO0", "sxyz"
      employer.update(
        reset_password_digest: ::BCrypt::Password.create(reset_password_token),
        reset_password_sent_at: Time.now,
      )
      EmailTriggerJob.perform_later(
        EmailTemplate::TRIGGER_EMPLOYER_PASSWORD_FORGOTTEN,
        employer.uuid,
        "reset_password_token" => reset_password_token,
      )
      true
    end
  end

  def valid_token?(token)
    employer &&
      employer.reset_password_digest &&
      ::BCrypt::Password.new(employer.reset_password_digest) == token &&
      (employer.reset_password_sent_at > Time.now - RESET_PASSWORD_WITHIN)
  end

  def update_password
    employer.set password: password
    employer.save raise_on_failure: false
  end

  private

  attr_reader :params

  def employer
    @employer ||= Employer.where(
      email: email,
      deleted_at: nil,
    ).qualify.eager_graph(:company).where(
      Sequel.qualify(:company, :deleted_at) => nil,
    ).limit(1).all.first
  end
end

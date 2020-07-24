class EmployerPortal::Context

  # ~~ subclasses ~~
  class NoAccount
    attr_reader :id, :company
  end

  # ~~ delegates ~~
  delegate :id, to: :account, prefix: :account
  delegate :first_name, :email, :company, :company_id, to: :account

  # ~~ public instance methods ~~
  def initialize(account_id:, section:)
    @given_account_id = account_id
    @section = section
    Sequel::Plugins::WithAudits.audited_by account
  end

  def account
    @account ||= find_account_by_id || no_account
  end

  def signed_in?
    !account.kind_of?(NoAccount)
  end

  def sync_connected?
    ::EmployerPortal::Sync.connected?
  end

  def daily_checkup_enabled?
    return false unless sync_connected?

    !!company.plan&.daily_checkup_enabled
  end

  def testing_enabled?
    return false unless sync_connected?

    !!company.plan&.testing_enabled
  end

  def health_passport_enabled?
    return false unless sync_connected?

    !!company.plan&.health_passport_enabled
  end

  def section_admin?
    section == :admin
  end

  def section_application?
    section == :application
  end

  def disabled_feature_message
    if sync_connected?
      "Feature not included in your current plan"
    else
      "Temporarily unavailable, please come back later"
    end
  end

  def allowed_to_add_employees?
    !!account.try(:allowed_to_add_employees)
  end

  def allowed_to_add_employee_tags?
    !!account.try(:allowed_to_add_employee_tags)
  end

  def allowed_all_employee_tags?
    !!account.try(:allowed_all_employee_tags)
  end

  def allowed_employee_tags
    account.try(:allowed_employee_tags) || []
  end

  def with_overrides?
    (account&.company&.color_overrides || []).any? { |color, _| !color.start_with? "chart-" }
  end

  def timestamp
    account&.company&.updated_at.to_i
  end

  private

  attr_reader :given_account_id, :section

  # ~~ private instance methods ~~
  def find_account_by_id
    return unless given_account_id

    if section_admin?
      AdminUser.where(id: given_account_id).limit(1).first
    elsif section_application?
      Employer.eager_graph(:company).eager(company: :plan).where(
        Sequel.qualify(:employers, :id) => given_account_id,
        Sequel.qualify(:employers, :deleted_at) => nil,
        Sequel.qualify(:company, :deleted_at) => nil,
      ).limit(1).all.first
    end
  end

  def no_account
    NoAccount.new
  end
end

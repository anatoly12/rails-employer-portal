module EmployerPortal
  class Context
    class NoAccount
      attr_reader :id, :company
    end

    delegate :id, to: :account, prefix: :account
    delegate :first_name, :email, :company, :company_id, to: :account
    delegate :plan, to: :company, allow_nil: true, prefix: :company

    def initialize(account_id:, section:)
      @given_account_id = account_id
      @section = section
    end

    def account
      @account ||= find_account_by_id || no_account
    end

    def signed_in?
      !account.kind_of?(NoAccount) && account.deleted_at.nil?
    end

    def ensure_access!
      raise Error::Account::NotFound unless signed_in?
    end

    def testing_status_enabled?
      company_plan.present? && !company_plan.include?("Lite")
    end

    def billed_by_invoice?
      company_plan.present? && company_plan != "Self-Service"
    end

    def sync_connected?
      ::EmployerPortal::Sync.connected?
    end

    def aws_connected?
      ::EmployerPortal::Aws.connected?
    end

    private

    attr_reader :given_account_id, :section

    def section_admin?
      section == :admin
    end

    def find_account_by_id
      return unless given_account_id

      if section_admin?
        AdminUser.where(id: given_account_id).limit(1).first
      else
        Employer.where(id: given_account_id).limit(1).first
      end
    end

    def no_account
      NoAccount.new
    end
  end
end

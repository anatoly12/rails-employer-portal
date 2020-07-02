module EmployerPortal
  class Context
    class NoAccount
      attr_reader :id, :company
    end

    delegate :id, to: :account, prefix: :account
    delegate :first_name, :email, :company, :company_id, to: :account

    def initialize(account_id:, section:)
      @given_account_id = account_id
      @section = section
    end

    def account
      @account ||= find_account_by_id || no_account
    end

    def signed_in?
      !account.kind_of?(NoAccount)
    end

    def ensure_access!
      raise Error::Account::NotFound unless signed_in?
    end

    def sync_connected?
      ::EmployerPortal::Sync.connected?
    end

    def aws_connected?
      ::EmployerPortal::Aws.connected?
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
end

module EmployerPortal
  class Context
    class NoAccount
      attr_reader :id, :company
    end

    delegate :id, to: :account, prefix: :account
    delegate :first_name, :company, :company_id, to: :account
    delegate :plan, to: :company, allow_nil: true, prefix: :company

    def initialize(hash = {})
      @hash = hash
    end

    def account
      @account ||= begin
          given_account_id = hash[:account_id]
          (find_account_by_id given_account_id if given_account_id) || no_account
        end
    end

    def signed_in?
      !account.kind_of?(NoAccount)
    end

    def ensure_access!
      raise Error::Account::NotFound unless signed_in?
    end

    def testing_status_enabled?
      company_plan.present? && !company_plan.include?("Lite")
    end

    private

    attr_reader :hash

    def find_account_by_id(id)
      Employer.where(id: id).limit(1).first
    end

    def no_account
      NoAccount.new
    end
  end
end

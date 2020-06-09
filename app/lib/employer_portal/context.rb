module EmployerPortal
  class Context
    class NoAccount
      attr_reader :id
    end

    delegate :id, to: :account, prefix: :account

    def initialize(hash={})
      @hash = hash
    end

    def account
      @account ||= begin
        given_account_id = hash[:account_id]
        (find_account_by_id given_account_id if given_account_id) || no_account
      end
    end

    def ensure_access!
      raise Error::Account::NotFound unless account.id
    end

    private

    attr_reader :hash

    def find_account_by_id(id)
      User.where(id: id).limit(1).first
    end

    def no_account
      NoAccount.new
    end
  end
end
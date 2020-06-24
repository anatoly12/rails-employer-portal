module EmployerPortal
  class Sync
    class Legacy
      def initialize(schema, klass)
        @schema = schema
        @klass = klass
      end

      def define_models
        klass.const_set :Account, account_class
        klass.const_set :AccountAccessGrant, account_access_grant_class
        klass.const_set :AccountDemographic, account_demographic_class
        klass.const_set :PartnerAccessCode, partner_access_code_class
        klass.const_set :User, user_class
      end

    private

      attr_reader :schema, :klass

      def db
        Sequel::Model.db
      end

      def account_class
        prefix = klass.to_s
        Class.new(
          Sequel::Model(db[schema[:accounts]])
        ) {
          many_to_one :user, class: "#{prefix}::User"
          one_to_one :demographic, class: "#{prefix}::AccountDemographic", key: :account_id
          one_to_many :access_grants, class: "#{prefix}::AccountAccessGrant", key: :account_id
          plugin :timestamps, update_on_create: true
        }
      end

      def account_access_grant_class
        prefix = klass.to_s
        Class.new(
          Sequel::Model(db[schema[:account_access_grants]])
        ) {
          many_to_one :account, class: "#{prefix}::Account"
          many_to_one :partner_access_code, class: "#{prefix}::PartnerAccessCode"
          plugin :timestamps, update_on_create: true
        }
      end

      def account_demographic_class
        prefix = klass.to_s
        Class.new(
          Sequel::Model(db[schema[:account_demographics]])
        ) {
          many_to_one :account, class: "#{prefix}::Account"
          plugin :timestamps, update_on_create: true
        }
      end

      def partner_access_code_class
        Class.new(
          Sequel::Model(db[schema[:partner_access_codes]])
        )
      end

      def user_class
        prefix = klass.to_s
        Class.new(
          Sequel::Model(db[schema[:ec_users]])
        ) {
          one_to_one :account, class: "#{prefix}::Account", key: :account_id
          plugin :timestamps, update_on_create: true
        }
      end
    end
  end
end

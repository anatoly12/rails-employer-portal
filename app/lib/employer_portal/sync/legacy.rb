module EmployerPortal
  module Sync
    class Legacy
      def initialize(schema, klass)
        @schema = schema
        @klass = klass
      end

      def define_models
        klass.const_set :AccessCode, access_code_class
        klass.const_set :AccessGrant, access_grant_class
        klass.const_set :Account, account_class
        klass.const_set :Demographic, demographic_class
        klass.const_set :Kit, kit_class
        klass.const_set :Partner, partner_class
        klass.const_set :PassportProduct, passport_product
        klass.const_set :Requisition, requisition_class
        klass.const_set :TKit, t_kit_class
        klass.const_set :User, user_class
      end

      private

      attr_reader :schema, :klass

      def db
        Sequel::Model.db
      end

      def access_code_class
        prefix = klass.to_s
        Class.new(
          Sequel::Model(db[schema[:partner_access_codes]])
        ) {
          many_to_one :partner, class: "#{prefix}::Partner"
          plugin :timestamps, update_on_create: true
        }
      end

      def access_grant_class
        prefix = klass.to_s
        Class.new(
          Sequel::Model(db[schema[:account_access_grants]])
        ) {
          many_to_one :account, class: "#{prefix}::Account"
          many_to_one :access_code, class: "#{prefix}::AccessCode", key: :partner_access_code_id
          plugin :timestamps, update_on_create: true
        }
      end

      def account_class
        prefix = klass.to_s
        Class.new(
          Sequel::Model(db[schema[:accounts]])
        ) {
          many_to_one :user, class: "#{prefix}::User"
          one_to_one :demographic, class: "#{prefix}::Demographic", key: :account_id
          one_to_many :access_grants, class: "#{prefix}::AccessGrant", key: :account_id
          plugin :timestamps, update_on_create: true
        }
      end

      def demographic_class
        prefix = klass.to_s
        Class.new(
          Sequel::Model(db[schema[:account_demographics]])
        ) {
          many_to_one :account, class: "#{prefix}::Account"
          plugin :timestamps, update_on_create: true
        }
      end

      def kit_class
        prefix = klass.to_s
        Class.new(
          Sequel::Model(db[schema[:ec_kits]])
        ) {
          many_to_one :t_kit, class: "#{prefix}::TKit"
          many_to_one :partner, class: "#{prefix}::Partner"
          many_to_one :requisition, class: "#{prefix}::Requisition"
          plugin :timestamps, update_on_create: true
        }
      end

      def partner_class
        prefix = klass.to_s
        Class.new(
          Sequel::Model(db[schema[:ec_partners]])
        ) {
          many_to_one :passport_product, class: "#{prefix}::PassportProduct"
          one_to_many :access_codes, class: "#{prefix}::AccessCode"
          plugin :timestamps, update_on_create: true
        }
      end

      def passport_product
        prefix = klass.to_s
        Class.new(
          Sequel::Model(db[schema[:passport_products]])
        ) {
          many_to_one :t_kit, class: "#{prefix}::TKit"
          plugin :timestamps, update_on_create: true
        }
      end

      def requisition_class
        prefix = klass.to_s
        Class.new(
          Sequel::Model(db[schema[:ec_requisitions]])
        ) {
          many_to_one :user, class: "#{prefix}::User"
          one_to_one :kit, class: "#{prefix}::Kit"
          plugin :timestamps, update_on_create: true
        }
      end

      def t_kit_class
        prefix = klass.to_s
        Class.new(
          Sequel::Model(db[schema[:ec_t_kits]])
        ) {
          plugin :timestamps, update_on_create: true
        }
      end

      def user_class
        prefix = klass.to_s
        Class.new(
          Sequel::Model(db[schema[:ec_users]])
        ) {
          one_to_one :account, class: "#{prefix}::Account", key: :account_id
          one_to_many :requisitions, class: "#{prefix}::Requisition"
          plugin :timestamps, update_on_create: true
        }
      end
    end
  end
end

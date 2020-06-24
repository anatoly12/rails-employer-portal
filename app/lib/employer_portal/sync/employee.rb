module EmployerPortal
  module Sync
    class Employee
      SYNC_SECRET_KEY_BASE = ENV["SYNC_SECRET_KEY_BASE"]

      def initialize(schema, secret_key_base, employee, now = Time.now)
        @schema = schema
        @secret_key_base = secret_key_base
        @employee = employee
        @now = now
      end

      def create_account!
        db.transaction do
          account = create_or_update_account
          create_user_if_needed(account)
          create_demographic_if_needed(account)
          create_requisition(account)
          create_access_grant(account)
          employee.update remote_id: account.id
        end
      rescue Sequel::Error => e
        raise ::EmployerPortal::Error::Sync::CantCreateAccount, e.message
      end

      private

      attr_reader :schema, :secret_key_base, :employee, :now

      def db
        Sequel::Model.db
      end

      def devise_reset_password_token
        key = ActiveSupport::KeyGenerator.new(
          secret_key_base
        ).generate_key("Devise reset_password_token")
        loop do
          raw = SecureRandom.urlsafe_base64(15).tr("lIO0", "sxyz")
          enc = OpenSSL::HMAC.hexdigest("SHA256", key, raw)
          break enc if Account.where(reset_password_token: enc).limit(1).empty?
        end
      end

      def create_or_update_account
        account_id = Account.dataset.on_duplicate_key_update(
          :is_active,
          :reset_password_token,
          :reset_password_sent_at,
          :updated_at
        ).insert(
          email: employee.email,
          is_active: true,
          reset_password_token: devise_reset_password_token,
          reset_password_sent_at: now,
          created_at: now,
          updated_at: now,
        )
        Account[account_id]
      end

      def create_user_if_needed(account)
        return if account.user_id

        account.update user_id: User.insert(
          email: employee.email,
          first_name: employee.first_name,
          last_name: employee.last_name,
          created_at: now,
          updated_at: now,
        )
      end

      def create_demographic_if_needed(account)
        return if account.demographic

        Demographic.create(
          account_id: account.id,
          full_legal_name: employee.full_name,
          state_of_residence: employee.state,
          phone_number: employee.phone,
          created_at: now,
          updated_at: now,
        )
      end

      def partner_id
        employee.company.remote_id
      end

      def create_requisition(account)
        return unless partner_id

        # Requisition.create(
        #   requisition_id: Kit.where(
        #   ) schema[:ec_kits][:requisition_id]
        #   user_id: account.user_id,
        # )
        # .left_join(schema[:ec_requisitions], requisition_id: schema[:ec_kits][:requisition_id])
        # .left_join(schema[:accounts], user_id: schema[:ec_requisitions][:user_id])
        # - `Partner` - pre-exists in the db created by EHS technical staff
        # - `PartnerAccessCode` - 0..N pre-exist in the db created by EHS technical staff
        # - User provides a valid access code
        #   - `TKit` - found in the db, created by EHS technical staff
        #   - `Kit` - created for the `TKit` and `Partner`
        #   - `Requisition` - created for the `Kit` and `Account`
      end

      def create_access_grant(account)
        return unless partner_id
        return if account.access_grants.any? { |g| g.access_code.partner_id == partner_id }

        access_code_id = AccessCode.where(partner_id: partner_id).get(:id)
        return unless access_code_id

        AccessGrant.create(
          account_id: account.id,
          partner_access_code_id: access_code_id,
          created_at: now,
          updated_at: now,
        )
      end
    end
  end
end

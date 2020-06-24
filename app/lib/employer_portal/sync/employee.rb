module EmployerPortal
  class Sync
    class Employee
      SYNC_SECRET_KEY_BASE = ENV["SYNC_SECRET_KEY_BASE"]

      def initialize(schema, secret_key_base, employee, now=Time.now)
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
          link_to_partner(account)
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

        AccountDemographic.create(
          account_id: account.id,
          full_legal_name: employee.full_name,
          state_of_residence: employee.state,
          phone_number: employee.phone,
          created_at: now,
          updated_at: now
        )
      end

      def partner_id
        employee.company.remote_id
      end

      def link_to_partner(account)
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
        #   - `AccountAccessGrant` - created for the `Account` tying them to the `Partner`
        partner_access_code_id = PartnerAccessCode.where(
          partner_id: partner_id
        ).get(:id)
        AccountAccessGrant.create(
          account_id: account_id,
          partner_access_code_id: partner_access_code_id,
          created_at: now,
          updated_at: now
        ) if partner_access_code_id && account.access_grants.none?{|g| g.partner_id==partner_id}
      end
    end
  end
end

module EmployerPortal
  class RemoteDb
    class << self
      attr_reader :db

      def init
        connect
        create_or_replace_views
      end

    private

      def connect
        @db.disconnect if defined? @db
        @db = Sequel.connect ENV["SYNC_DATABASE_URL"]
        Rails.logger.info "Successfully connected to remote DB..."
      rescue Sequel::DatabaseConnectionError
        abort "Can't connect to remote DB, please check that SYNC_DATABASE_URL is correctly configured."
      end

      def create_or_replace_views
        Rails.logger.info "Create or replace views..."
        db.create_or_replace_view(
          :employer_portal_employees,
          db[:accounts]
            .left_join(:account_demographics, account_id: Sequel.qualify(:accounts, :id))
            .left_join(:identities, account_id: Sequel.qualify(:accounts, :id))
            .left_join(:account_access_grants, account_id: Sequel.qualify(:accounts, :id))
            .left_join(:partner_access_codes, id: Sequel.qualify(:account_access_grants, :partner_access_code_id))
            .left_join(:covid19_daily_checkups, account_id: Sequel.qualify(:accounts, :id), updated_at: db[:covid19_daily_checkups].where(account_id: Sequel.qualify(:accounts, :id)).select(Sequel.function(:max, :updated_at)))
            .left_join(:covid19_daily_checkup_statuses, daily_checkup_status_code: Sequel.qualify(:covid19_daily_checkups, :daily_checkup_status_code))
            .select(
              Sequel.qualify(:accounts, :id).as(:id),
              Sequel.qualify(:account_demographics, :full_legal_name).as(:full_name),
              Sequel.qualify(:account_demographics, :state_of_residence).as(:state),
              Sequel.qualify(:identities, :selfie_s3_key).as(:selfie_s3_key),
              db[:identities].columns.include?(:identity_approved) ?
                Sequel.qualify(:identities, :identity_approved).as(:identity_approved) :
                Sequel.lit("FALSE").as(:identity_approved),
              Sequel.qualify(:partner_access_codes, :partner_id).as(:partner_id),
              Sequel.function(:coalesce, Sequel.qualify(:covid19_daily_checkup_statuses, :daily_checkup_status), "Did Not Submit").as(:daily_checkup_status),
              db[:covid19_daily_checkups].columns.include?(:checkup_date) ?
                Sequel.qualify(:covid19_daily_checkups, :checkup_date).as(:daily_checkup_updated_at) :
                Sequel.function(:date, Sequel.qualify(:covid19_daily_checkups, :updated_at)).as(:daily_checkup_updated_at),
              Sequel.case([
                [{Sequel.qualify(:covid19_daily_checkups, :daily_checkup_status_code) => 1}, "Cleared"],
                [{Sequel.qualify(:covid19_daily_checkups, :daily_checkup_status_code) => 2}, "Contact"],
              ], "Send Reminder").as(:daily_checkup_action)
            )
        )
        #         case when ce.status in (1,4) then 'Cleared'
        #          when ce.status = 5 then 'Inconclusive'
        #              when ce.lab_review_approved then 'Submitted Results'
        #              when ce.identity_approved then 'Intake'
        #              when ce.status is not null then 'Registered'
        #              else 'Not Registered'
        #         end as `Testing Status`,
        #         ce.updated_at as `Last Updated`
        # left join covid19_evaluations ce on ce.account_id = a.id
      end
    end
  end
end

module EmployerPortal
  class RemoteDb
    class << self
      attr_reader :db

      def init
        @url = ENV["SYNC_DATABASE_URL"]
        if url.present?
          connect
          create_or_replace_views
        else
          puts "SYNC_DATABASE_URL not configured, skip connection to remote DB..."
        end
      end

    private

      attr_reader :url

      def connect
        @db.disconnect if defined? @db
        @db = Sequel.connect url
        puts "Successfully connected to remote DB..."
      rescue Sequel::DatabaseConnectionError
        abort "Can't connect to remote DB, please check that SYNC_DATABASE_URL is correctly configured."
      end

      def create_or_replace_views
        # use query cache to speed up the view
        # https://jacobt.com/speed-up-your-app-with-mysql-views-and-query-cache/
        db.create_or_replace_view(
          :employer_portal_employees,
          db[:accounts]
            .left_join(:account_demographics, account_id: Sequel.qualify(:accounts, :id))
            .left_join(:identities, account_id: Sequel.qualify(:accounts, :id))
            .left_join(:account_access_grants, account_id: Sequel.qualify(:accounts, :id))
            .left_join(:partner_access_codes, id: Sequel.qualify(:account_access_grants, :partner_access_code_id))
            .left_join(:covid19_daily_checkups, account_id: Sequel.qualify(:accounts, :id), updated_at: db[:covid19_daily_checkups].where(account_id: Sequel.qualify(:accounts, :id)).select(Sequel.function(:max, :updated_at)))
            .left_join(:covid19_daily_checkup_statuses, daily_checkup_status_code: Sequel.qualify(:covid19_daily_checkups, :daily_checkup_status_code))
            .left_join(:covid19_evaluations, account_id: Sequel.qualify(:accounts, :id))
            .group_by(Sequel.qualify(:accounts, :id))
            .exclude(Sequel.qualify(:partner_access_codes, :partner_id) => nil)
            .select(
              Sequel.lit("SQL_CACHE ?", Sequel.qualify(:accounts, :id)).as(:id),
              Sequel.function(:any_value,
                Sequel.qualify(:account_demographics, :full_legal_name)
              ).as(:full_name),
              Sequel.function(:any_value,
                Sequel.qualify(:account_demographics, :state_of_residence)
              ).as(:state),
              Sequel.function(:any_value,
                Sequel.qualify(:identities, :selfie_s3_key)
              ).as(:selfie_s3_key),
              (
                db[:identities].columns.include?(:identity_approved) ?
                  Sequel.function(:any_value, Sequel.qualify(:identities, :identity_approved)) :
                  Sequel.lit("FALSE")
              ).as(:identity_approved),
              Sequel.function(:any_value,
                Sequel.qualify(:partner_access_codes, :partner_id)
              ).as(:partner_id),
              Sequel.function(:coalesce,
                Sequel.function(:any_value,
                  Sequel.qualify(:covid19_daily_checkup_statuses, :daily_checkup_status)
                ),
                "Did Not Submit"
              ).as(:daily_checkup_status),
              (
                db[:covid19_daily_checkups].columns.include?(:checkup_date) ?
                  Sequel.function(:any_value, Sequel.qualify(:covid19_daily_checkups, :checkup_date)).as(:daily_checkup_updated_at) :
                  Sequel.function(:any_value, Sequel.function(:date, Sequel.qualify(:covid19_daily_checkups, :updated_at)))
              ).as(:daily_checkup_updated_at),
              Sequel.function(:any_value,
                Sequel.case([
                  [{Sequel.qualify(:covid19_daily_checkups, :daily_checkup_status_code) => 1}, "Cleared"],
                  [{Sequel.qualify(:covid19_daily_checkups, :daily_checkup_status_code) => 2}, "Contact"],
                ], "Send Reminder")
              ).as(:daily_checkup_action),
              Sequel.function(:any_value,
                Sequel.case([
                  [{Sequel.qualify(:covid19_evaluations, :status) => [1, 4]}, "Cleared"],
                  [{Sequel.qualify(:covid19_evaluations, :status) => 5}, "Inconclusive"],
                  [{Sequel.qualify(:covid19_evaluations, :lab_review_approved) => true}, "Submitted Results"],
                  [{Sequel.qualify(:covid19_evaluations, :identity_approved) => true}, "Intake"],
                  [Sequel.negate(Sequel.qualify(:covid19_evaluations, :status) => nil), "Registered"],
                ], "Not Registered")
              ).as(:testing_status),
              Sequel.function(:any_value,
                Sequel.function(:date, Sequel.qualify(:covid19_evaluations, :updated_at))
              ).as(:testing_updated_at)
            )
        )
        db.create_or_replace_view(
          :employer_portal_symptom_logs,
          db[:ec_questions]
            .left_join(:ec_kits, kit_id: Sequel.qualify(:ec_questions, :kit_id))
            .left_join(:ec_requisitions, requisition_id: Sequel.qualify(:ec_kits, :requisition_id))
            .left_join(:accounts, user_id: Sequel.qualify(:ec_requisitions, :user_id))
            .group_by(
              Sequel.qualify(:accounts, :id),
              Sequel.function(:date, Sequel.qualify(:ec_questions, :updated_at)),
            )
            .exclude(Sequel.qualify(:accounts, :id) => nil)
            .select(
              Sequel.lit("SQL_CACHE ?", Sequel.qualify(:accounts, :id)).as(:account_id),
              Sequel.function(:date, Sequel.qualify(:ec_questions, :updated_at)).as(:log_date),
              Sequel.function(:max, {Sequel.qualify(:ec_kits, :flagged_status) => "FLAGGED"}).as(:flagged),
              Sequel.function(:max,
                Sequel.case([
                  [{Sequel.qualify(:ec_questions, :question) => "Temperature"}, Sequel.qualify(:ec_questions, :response)],
                ], nil)
              ).as(:temperature),
              Sequel.function(:max,
                Sequel.case([
                  [{
                    Sequel.qualify(:ec_questions, :sub_group) => "Symptoms",
                    Sequel.qualify(:ec_questions, :response) => "Yes"
                  }, true],
                ], false)
              ).as(:symptoms)
            )
        )
        db.create_or_replace_view(
          :employer_portal_symptom_log_entries,
          db[:ec_questions]
            .left_join(:ec_kits, kit_id: Sequel.qualify(:ec_questions, :kit_id))
            .left_join(:ec_requisitions, requisition_id: Sequel.qualify(:ec_kits, :requisition_id))
            .left_join(:accounts, user_id: Sequel.qualify(:ec_requisitions, :user_id))
            .left_join(:ec_data_types, data_type_id: Sequel.qualify(:ec_questions, :data_type_id))
            .left_join(:ec_list_items, list_id: Sequel.qualify(:ec_data_types, :list_id))
            .exclude(Sequel.qualify(:accounts, :id) => nil)
            .group_by(Sequel.qualify(:ec_questions, :question_id))
            .where(
              Sequel.qualify(:ec_data_types, :type_of) => ["DATE", "TEXT", "LIST_OPT"]
            )
            .select(
              Sequel.lit("SQL_CACHE ?", Sequel.qualify(:ec_questions, :question_id)).as(:id),
              Sequel.function(:any_value,
                Sequel.qualify(:accounts, :id)
              ).as(:account_id),
              Sequel.function(:date, Sequel.qualify(:ec_questions, :updated_at)).as(:log_date),
              Sequel.qualify(:ec_questions, :question).as(:question),
              Sequel.qualify(:ec_questions, :response).as(:response),
              Sequel.qualify(:ec_data_types, :type_of).as(:question_type),
              Sequel.function(:group_concat, Sequel.qualify(:ec_list_items, :item)).as(:options)
            )
        )
      end
    end
  end
end

class EmployerPortal::Sync::Views

  # ~~ public instance methods ~~
  def initialize(schema)
    @schema = schema
  end

  def create_or_replace
    create_or_replace_dashboard_employees
    create_or_replace_symptom_logs
    create_or_replace_symptom_log_entries
    DashboardEmployee.columns
    SymptomLog.columns
    SymptomLogEntry.columns
  end

  private

  attr_reader :schema

  # ~~ private instance methods ~~
  def db
    Sequel::Model.db
  end

  def any_value(column)
    Sequel.function(:any_value, column)
  end

  def create_or_replace_dashboard_employees
    # use query cache to speed up the view
    # https://jacobt.com/speed-up-your-app-with-mysql-views-and-query-cache/
    db.create_or_replace_view(
      :dashboard_employees,
      db[schema[:accounts]]
        .left_join(schema[:account_demographics], account_id: schema[:accounts][:id])
        .left_join(schema[:identities], account_id: schema[:accounts][:id])
        .left_join(schema[:account_access_grants], account_id: schema[:accounts][:id])
        .left_join(schema[:partner_access_codes], id: schema[:account_access_grants][:partner_access_code_id])
        .left_join(schema[:covid19_daily_checkups], account_id: schema[:accounts][:id], updated_at: db[schema[:covid19_daily_checkups]].where(account_id: schema[:accounts][:id]).select(Sequel.function(:max, :updated_at)))
        .left_join(schema[:covid19_evaluations], account_id: schema[:accounts][:id])
        .group_by(schema[:accounts][:id])
        .exclude(schema[:partner_access_codes][:partner_id] => nil)
        .select(
          Sequel.lit("SQL_CACHE ?", schema[:accounts][:id]).as(:id),
          any_value(
            schema[:account_demographics][:full_legal_name]
          ).as(:full_name),
          any_value(
            schema[:account_demographics][:state_of_residence]
          ).as(:state),
          schema[:accounts][:is_active],
          any_value(
            schema[:identities][:selfie_s3_key]
          ).as(:selfie_s3_key),
          any_value(
            schema[:identities][:identity_verified]
          ).as(:identity_verified),
          any_value(
            schema[:partner_access_codes][:partner_id]
          ).as(:partner_id),
          any_value(
            Sequel.case(
              [
                [{ schema[:covid19_daily_checkups][:daily_checkup_status_code] => 2 }, "Not Cleared"],
                [{ schema[:covid19_daily_checkups][:daily_checkup_status_code] => 1, schema[:covid19_daily_checkups][:checkup_date] => Sequel.function(:curdate) }, "Cleared"],
              ],
              "Did Not Submit"
            )
          ).as(:daily_checkup_status),
          any_value(
            schema[:covid19_daily_checkups][:checkup_date]
          ).as(:daily_checkup_updated_at),
          any_value(
            Sequel.case(
              [
                [{ schema[:covid19_evaluations][:status] => [1, 4] }, "Cleared"],
                [{ schema[:covid19_evaluations][:status] => 5 }, "Inconclusive"],
                [{ schema[:covid19_evaluations][:lab_review_approved] => true }, "Submitted Results"],
                [{ schema[:covid19_evaluations][:identity_approved] => true }, "Intake"],
                [Sequel.negate(schema[:covid19_evaluations][:status] => nil), "Registered"],
              ],
              "Not Registered"
            )
          ).as(:testing_status),
          any_value(
            Sequel.function(:date, schema[:covid19_evaluations][:updated_at])
          ).as(:testing_updated_at)
        )
    )
  end

  def create_or_replace_symptom_logs
    db.create_or_replace_view(
      :symptom_logs,
      db[schema[:ec_questions]]
        .left_join(schema[:ec_kits], kit_id: schema[:ec_questions][:kit_id])
        .left_join(schema[:ec_requisitions], requisition_id: schema[:ec_kits][:requisition_id])
        .left_join(schema[:accounts], user_id: schema[:ec_requisitions][:user_id])
        .group_by(
          schema[:accounts][:id],
          Sequel.function(:date, schema[:ec_questions][:updated_at]),
        )
        .exclude(schema[:accounts][:id] => nil)
        .select(
          Sequel.lit("SQL_CACHE ?", schema[:accounts][:id]).as(:account_id),
          Sequel.function(
            :date,
            schema[:ec_questions][:updated_at]
          ).as(:log_date),
          Sequel.function(
            :max,
            schema[:ec_kits][:flagged_status] => "FLAGGED",
          ).as(:flagged),
          Sequel.function(
            :max,
            Sequel.case(
              [
                [{ schema[:ec_questions][:question] => "Temperature" }, schema[:ec_questions][:response]],
              ],
              nil
            )
          ).as(:temperature),
          Sequel.function(
            :max,
            Sequel.case(
              [
                [
                  {
                    schema[:ec_questions][:sub_group] => "Symptoms",
                    schema[:ec_questions][:response] => "Yes",
                  },
                  true,
                ],
              ],
              false
            )
          ).as(:symptoms)
        )
    )
  end

  def create_or_replace_symptom_log_entries
    db.create_or_replace_view(
      :symptom_log_entries,
      db[schema[:ec_questions]]
        .left_join(schema[:ec_kits], kit_id: schema[:ec_questions][:kit_id])
        .left_join(schema[:ec_requisitions], requisition_id: schema[:ec_kits][:requisition_id])
        .left_join(schema[:accounts], user_id: schema[:ec_requisitions][:user_id])
        .left_join(schema[:ec_data_types], data_type_id: schema[:ec_questions][:data_type_id])
        .left_join(schema[:ec_list_items], list_id: schema[:ec_data_types][:list_id])
        .exclude(schema[:accounts][:id] => nil)
        .group_by(schema[:ec_questions][:question_id])
        .where(
          schema[:ec_data_types][:type_of] => ["DATE", "TEXT", "LIST_OPT"],
        )
        .select(
          Sequel.lit("SQL_CACHE ?", schema[:ec_questions][:question_id]).as(:id),
          any_value(
            schema[:accounts][:id]
          ).as(:account_id),
          Sequel.function(
            :date,
            schema[:ec_questions][:updated_at]
          ).as(:log_date),
          schema[:ec_questions][:question],
          schema[:ec_questions][:response],
          schema[:ec_questions][:required],
          schema[:ec_data_types][:type_of].as(:question_type),
          Sequel.lit(
            "GROUP_CONCAT(? ORDER BY ? ASC SEPARATOR ?)",
            schema[:ec_list_items][:item],
            schema[:ec_list_items][:list_item_id],
            "||"
          ).as(:options)
        )
    )
  end
end

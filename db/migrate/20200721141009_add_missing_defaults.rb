# frozen_string_literal: true

Sequel.migration do
  change do
    alter_table :plans do
      [:daily_checkup_enabled, :testing_enabled, :health_passport_enabled].each do |column|
        set_column_default column, false
        set_column_allow_null column, false
      end
    end
  end
end

# frozen_string_literal: true

Sequel.migration do
  change do
    alter_table :companies do
      set_column_allow_null :plan_id, false
      drop_column :remote_sync_at
    end
  end
end

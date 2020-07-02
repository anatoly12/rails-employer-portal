# frozen_string_literal: true

Sequel.migration do
  change do
    Sequel::Model.db.run "SET FOREIGN_KEY_CHECKS=0"
    alter_table :companies do
      set_column_allow_null :plan_id, false
      drop_column :remote_sync_at
    end
    Sequel::Model.db.run "SET FOREIGN_KEY_CHECKS=1"
  end
end

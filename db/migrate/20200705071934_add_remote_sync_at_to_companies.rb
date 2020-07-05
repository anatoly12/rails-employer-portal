# frozen_string_literal: true

Sequel.migration do
  change do
    alter_table :companies do
      add_column :remote_sync_at, DateTime
    end
  end
end

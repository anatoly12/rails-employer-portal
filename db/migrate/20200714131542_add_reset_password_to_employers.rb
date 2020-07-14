# frozen_string_literal: true

Sequel.migration do
  change do
    alter_table :employers do
      add_column :reset_password_digest, String
      add_column :reset_password_sent_at, DateTime
    end
  end
end

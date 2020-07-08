# frozen_string_literal: true

Sequel.migration do
  change do
    alter_table :employees do
      add_column :contact_queued_at, DateTime
      add_column :reminder_queued_at, DateTime
    end
  end
end

# frozen_string_literal: true

Sequel.migration do
  change do
    alter_table :employers do
      drop_foreign_key [:company_id]
      drop_index [:company_id, :email]
      add_foreign_key [:company_id], :companies, on_delete: :cascade
      add_index :company_id
      add_index :email, unique: true
    end
  end
end

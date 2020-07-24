# frozen_string_literal: true

Sequel.migration do
  change do
    alter_table :companies do
      add_column :logo_s3_key, String
    end
  end
end

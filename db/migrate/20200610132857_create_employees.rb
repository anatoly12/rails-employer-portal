# frozen_string_literal: true

Sequel.migration do
  change do
    create_table :employees do
      primary_key :id
      foreign_key :company_id, table: :companies, null: false, on_delete: :cascade
      foreign_key :employer_id, table: :employers, on_delete: :set_null
      String :uuid, null: false, unique: true
      String :email
      String :first_name
      String :last_name
      String :phone
      String :state
      String :zipcode
      DateTime :created_at
      DateTime :updated_at
      index [:company_id, :email], unique: true
      index :employer_id

      # TODO: using bigint as primary is a bad idea in MySQL
      # https://logicalread.com/improve-perf-mysql-index-columns-mc12/
      # but we must match the type of accounts.id on the remote DB
      #
      # If we switch to PostgreSQL for both, we can use UUID as primary_key and
      # share a single UUID for both DB, then we wouldn't need the
      # remote_id column anymore.
      Bignum :remote_id
      DateTime :remote_sync_at
    end
  end
end

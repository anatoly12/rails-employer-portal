# frozen_string_literal: true

Sequel.migration do
  change do
    alter_table :employees do
      # TODO: using bigint as primary is a bad idea in MySQL
      # https://logicalread.com/improve-perf-mysql-index-columns-mc12/
      # but it's the type used on the remote DB.
      #
      # If we switch to PostgreSQL for both, we can use UUID as primary_key and
      # share a single UUID for both DB, then we wouldn't need the
      # sync_remote_id column anymore.
      add_column :sync_remote_id, :Bignum
      add_column :sync_last_at, DateTime
    end
  end
end

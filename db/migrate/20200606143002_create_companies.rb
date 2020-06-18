# frozen_string_literal: true

Sequel.migration do
  change do
    create_table :companies do
      # TODO: if we switch to PostgreSQL we can use UUID as primary key, which
      # doesn't work well in MySQL, even when stored as binary(16)
      # https://www.percona.com/blog/2019/11/22/uuids-are-popular-but-bad-for-performance-lets-discuss/
      primary_key :id
      String :uuid, null: false, unique: true
      String :name
      String :plan
      DateTime :created_at
      DateTime :updated_at

      # TODO: using bigint as primary is a bad idea in MySQL
      # https://logicalread.com/improve-perf-mysql-index-columns-mc12/
      # but we must match the type of ecp_partners.partner_id on the remote DB
      #
      # If we switch to PostgreSQL for both, we can use UUID as primary_key and
      # share a single UUID for both DB, then we wouldn't need the
      # remote_id column anymore.
      Bignum :remote_id
      DateTime :remote_sync_at
    end
  end
end

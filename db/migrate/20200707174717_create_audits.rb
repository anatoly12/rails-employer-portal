# frozen_string_literal: true

Sequel.migration do
  change do
    create_table :audits do
      primary_key :id
      String :item_type, null: false
      Bignum :item_id
      String :event, null: false
      Json :changes
      String :created_by_type
      Bignum :created_by_id
      DateTime :created_at, type: "DATETIME(6)", default: Sequel.lit("CURRENT_TIMESTAMP(6)")
      index [:item_type, :item_id]
    end
  end
end

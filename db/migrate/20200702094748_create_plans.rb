# frozen_string_literal: true

Sequel.migration do
  change do
    create_table :plans do
      primary_key :id
      String :uuid, null: false, unique: true
      String :name
      String :billed_by
      FalseClass :daily_checkup_enabled
      FalseClass :testing_enabled
      FalseClass :health_passport_enabled
      Integer :employer_limit, default: 0
      Integer :employee_limit, default: 0
      Bignum :remote_id # link to passport_products.passport_product_id
      DateTime :created_at
      DateTime :updated_at
      DateTime :deleted_at
    end
    alter_table :companies do
      drop_column :plan
      add_foreign_key :plan_id, :plans, on_delete: :no_action # can't delete currently used plan
      add_index :plan_id
    end
    alter_table :email_templates do
      add_foreign_key :plan_id, :plans, on_delete: :cascade
      add_index :plan_id
    end
  end
end

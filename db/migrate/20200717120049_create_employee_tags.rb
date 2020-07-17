# frozen_string_literal: true

Sequel.migration do
  change do
    create_table :employee_tags do
      primary_key :id
      foreign_key :company_id, table: :companies, null: false, on_delete: :cascade
      String :name
      DateTime :created_at
      DateTime :updated_at
      index [:company_id, :name], unique: true
    end
    create_table :employee_taggings do
      foreign_key :employee_id, table: :employees, null: false, on_delete: :cascade
      foreign_key :employee_tag_id, table: :employee_tags, null: false, on_delete: :cascade
      DateTime :created_at
      primary_key [:employee_id, :employee_tag_id]
    end
  end
end

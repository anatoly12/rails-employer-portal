# frozen_string_literal: true

Sequel.migration do
  change do
    create_table :email_logs do
      primary_key :id
      foreign_key :email_template_id, table: :email_templates, on_delete: :set_null
      foreign_key :company_id, table: :companies, on_delete: :set_null
      foreign_key :employer_id, table: :employers, on_delete: :set_null
      foreign_key :employee_id, table: :employees, on_delete: :set_null
      String :trigger_key
      String :from
      String :recipient
      String :subject
      String :html
      String :text
      Bignum :covid19_message_id
      DateTime :created_at
      index :email_template_id
      index :company_id
      index :employer_id
      index :employee_id
      index :trigger_key
    end
  end
end

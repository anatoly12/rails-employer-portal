# frozen_string_literal: true

Sequel.migration do
  change do
    alter_table :employers do
      add_column :allowed_to_add_employees, FalseClass, null: false, default: false
      add_column :allowed_to_add_employee_tags, FalseClass, null: false, default: false
      add_column :allowed_all_employee_tags, FalseClass, null: false, default: false
      add_column :allowed_employee_tags, "Json"
    end
    execute "UPDATE employers SET allowed_to_add_employees=TRUE, allowed_to_add_employee_tags=TRUE, allowed_all_employee_tags=TRUE, allowed_employee_tags='[]'"
  end
end

# frozen_string_literal: true

Sequel.migration do
  change do
    [:companies, :employers, :email_templates].each do |table|
      alter_table table do
        add_column :deleted_at, DateTime
      end
    end
  end
end

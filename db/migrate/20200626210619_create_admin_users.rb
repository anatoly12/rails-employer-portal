# frozen_string_literal: true

Sequel.migration do
  change do
    create_table :admin_users do
      primary_key :id
      String :email, null: false, unique: true
      String :password_digest
      DateTime :created_at
      DateTime :updated_at
    end
  end
end

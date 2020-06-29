# frozen_string_literal: true

Sequel.migration do
  change do
    create_table :email_templates do
      primary_key :id
      String :name
      String :trigger_key
      String :from
      String :subject
      String :html
      String :text
      Bignum :covid19_message_code
      DateTime :created_at
      DateTime :updated_at
      index :trigger_key
    end
  end
end

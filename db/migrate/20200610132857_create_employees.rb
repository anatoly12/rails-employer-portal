Sequel.migration do
  change do

    create_table :employees do
      primary_key :id
      foreign_key :employer_id, table: :employers, null: false, on_delete: :cascade
      String :uuid, null: false, unique: true
      String :email
      String :first_name
      String :last_name
      String :phone_number
      String :state
      DateTime :created_at
      DateTime :updated_at
    end

  end
end

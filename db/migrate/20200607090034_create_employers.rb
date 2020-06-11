Sequel.migration do
  change do
    create_table :employers do
      primary_key :id
      foreign_key :company_id, table: :companies, null: false, on_delete: :cascade
      String :uuid, null: false, unique: true
      String :email
      String :first_name
      String :last_name
      String :password_digest
      String :role
      DateTime :created_at
      DateTime :updated_at
      index [:company_id, :email], unique: true
    end
  end
end

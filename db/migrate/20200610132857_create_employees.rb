Sequel.migration do
  change do
    create_table :employees do
      primary_key :id
      foreign_key :company_id, table: :companies, null: false, on_delete: :cascade
      foreign_key :employer_id, table: :employers, on_delete: :set_null
      String :uuid, null: false, unique: true
      String :email
      String :first_name
      String :last_name
      String :phone
      String :state
      String :zipcode
      DateTime :created_at
      DateTime :updated_at
      index [:company_id, :email], unique: true
    end
  end
end

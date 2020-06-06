Sequel.migration do
  change do

    create_table :users do
      primary_key :id
      String :email
      String :first_name
      String :last_name
      String :password_digest
      DateTime :created_at
      DateTime :updated_at
    end

  end
end

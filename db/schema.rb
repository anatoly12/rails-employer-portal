Sequel.migration do
  change do
    create_table(:schema_migrations) do
      column :filename, "varchar(255)", :null => false

      primary_key [:filename]
    end

    create_table(:users) do
      primary_key :id, :type => "int(11)"
      column :email, "varchar(255)"
    end
  end
end
Sequel.migration do
  change do
    self << "INSERT INTO `schema_migrations` (`filename`) VALUES ('20200606090034_create_users.rb')"
  end
end

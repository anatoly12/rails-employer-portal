Sequel.migration do
  change do

    # TODO: if we switch to PostgreSQL we can use UUID as primary key, which
    # doesn't work well in MySQL, even when stored as binary(16)
    # https://www.percona.com/blog/2019/11/22/uuids-are-popular-but-bad-for-performance-lets-discuss/
    create_table :companies do
      primary_key :id
      String :uuid, null: false, unique: true
      String :name
      String :plan
      DateTime :created_at
      DateTime :updated_at
    end

  end
end

Sequel.migration do
  change do

    create_table :zip_codes do
      String :zip, primary_key: true
      String :city
      String :state
      Point :geopoint, null: false
      spatial_index :geopoint
    end

  end
end

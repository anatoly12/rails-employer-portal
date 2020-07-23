# frozen_string_literal: true

Sequel.migration do
  change do
    alter_table :companies do
      add_column :color_overrides, "Json"
    end
  end
end

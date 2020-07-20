Sequel.migration do
  change do
    alter_table(:locations) do
      add_column :description, String, null: true
    end
  end
end

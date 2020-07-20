Sequel.migration do
  change do
    create_table(:class_descriptions) do
      primary_key :id, type: :Bignum

      column  :program_id, :Bignum, null: true
      column  :session_type_id, :Bignum, null: true
      column  :level_id, :Bignum, null: true

      column  :name, String, null: true
      column  :description, String, null: true
      column  :notes, String, null: true
      column  :last_updated, DateTime, null: true

      column  :image_url, String, null: true
    end
  end
end
Sequel.migration do
  change do
    create_table(:class_schedules) do
      primary_key :id, type: :Bignum

      column :semester_id, :Bignum, null: true
      column :location_id, :Bignum, null: true
      column :staff_id, :Bignum, null: true
      column :class_description_id, :Bignum, null: true

      [:sunday, :monday, :tuesday,
        :wednesday, :thursday,
        :friday, :saturday].each do |day_name|
          column :"day_#{day_name}", TrueClass
        end

      column :start_time, DateTime
      column :end_time, DateTime
      column :start_date, DateTime
      column :end_date, DateTime
    end
  end
end
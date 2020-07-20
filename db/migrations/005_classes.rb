Sequel.migration do
  change do
    create_table(:classes) do
      primary_key     :id,                          type: :Bignum

      column          :class_description_id,           :Bignum, null: true
      column          :class_schedule_id,           :Bignum, null: true
      column  :location_id,        :Bignum, null: true
      column  :semester_id,        :Bignum, null: true
      column  :staff_id,           :Bignum, null: true

      column  :active, TrueClass, default: false
      column  :is_canceled, TrueClass, default: false
      column  :is_enrolled, TrueClass, default: false
      column  :is_waitlist_available, TrueClass, default: false
      column  :is_available, TrueClass, default: false
      column  :hide_cancel, TrueClass, default: false
      column  :substitute, TrueClass, default: false

      column  :max_capacity,        :Integer, null: true
      column  :web_capacity,        :Integer, null: true
      column  :web_booked,        :Integer, null: true
      column  :total_booked,        :Integer, null: true
      column  :total_booked_waitlist,        :Integer, null: true

      column  :start_date_time, DateTime, null: true
      column  :end_date_time, DateTime, null: true
    end
  end
end
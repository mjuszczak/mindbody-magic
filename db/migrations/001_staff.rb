Sequel.migration do
  change do
    create_table(:staff) do
      primary_key     :id,                          type: :Bignum

      column          :name,                        String
      column          :first_name,                  String
      column          :last_name,                   String

      column          :is_male,                     TrueClass, default: false

      column          :address,                     String, null: true
      column          :state,                       String, null: true
      column          :city,                        String, null: true
      column          :country,                     String, null: true
      column          :postal_code,                 String, null: true

      column          :bio,                         String, null: true
      column          :mobile_phone,                String, null: true
      column          :home_phone,                  String, null: true
      column          :work_phone,                  String, null: true
      column          :email,                       String, null: true

      column          :image_url,                   String, null: true

      column          :appointment_trn,             TrueClass, default: false
      column          :reservation_trn,             TrueClass, default: false
      column          :independent_contractor,      TrueClass, default: false
      column          :always_allow_double_booking, TrueClass, default: false
      column          :sort_order,                  :Integer,  default: 0
    end
  end
end
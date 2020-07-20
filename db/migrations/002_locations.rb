Sequel.migration do
  change do
    create_table(:locations) do
      primary_key     :id,                          type: :Bignum

      column          :site_id,                     :Bignum

      column  :business_description,        String, null: true
      column  :name,        String, null: true
      column  :address,        String, null: true
      column  :address2,        String, null: true
      column  :phone,        String, null: true
      column  :phone_extension,        String, null: true
      column  :city,        String, null: true
      column  :state_prov_code,        String, null: true
      column  :postal_code,        String, null: true

      column  :tax1, BigDecimal, size: [ 3, 2 ]
      column  :tax2, BigDecimal, size: [ 3, 2 ]
      column  :tax3, BigDecimal, size: [ 3, 2 ]
      column  :tax4, BigDecimal, size: [ 3, 2 ]
      column  :tax5, BigDecimal, size: [ 3, 2 ]

      column  :latitude, BigDecimal, size: [ 12, 9 ]
      column  :longitude, BigDecimal, size: [ 12, 9 ]

      column  :has_classes, TrueClass, default: false
    end
  end
end
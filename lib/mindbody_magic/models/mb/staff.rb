module MindbodyMagic
  module Models
    module MB
      class Staff < Sequel::Model(:staff)
        Staff.unrestrict_primary_key
      end
    end
  end
end

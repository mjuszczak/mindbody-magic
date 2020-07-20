module MindbodyMagic
  module Models
    module MB
      class Location < Sequel::Model(:locations)
        Location.unrestrict_primary_key
      end
    end
  end
end

module MindbodyMagic
  module Models
    module MB
      class MBClassDescription < Sequel::Model(:class_descriptions)
        MBClassDescription.unrestrict_primary_key
      end
    end
  end
end

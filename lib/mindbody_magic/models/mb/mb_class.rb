module MindbodyMagic
  module Models
    module MB
      class MBClass < Sequel::Model(:classes)
        MBClass.unrestrict_primary_key
      end
    end
  end
end

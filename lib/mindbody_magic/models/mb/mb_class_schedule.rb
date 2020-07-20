module MindbodyMagic
  module Models
    module MB
      class MBClassSchedule < Sequel::Model(:class_schedules)
        MBClassSchedule.unrestrict_primary_key
      end
    end
  end
end

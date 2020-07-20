require 'mindbody_magic/models'

module MindbodyMagic
  module Tasks
    class RefreshDB
      def refresh_all
        {
          locations: refresh_locations,
          staff: refresh_staff,
          class_descriptions: refresh_class_descriptions,
          class_schedules: refresh_class_schedules,
          classes: refresh_classes,
          # clients: refresh_clients
        }
      end

      def refresh_locations
        mb_req(
          MindbodyMagic::Models::MB::Location,
          MindBody::Services::SiteService::get_locations \
            .body.dig(:get_locations_response, :get_locations_result),
          :locations
        ) do |mb_location|
            [
              :additional_image_ur_ls, :facility_square_feet, :treatment_rooms
            ].each { |key| mb_location.delete(key) }

            (1..5).each do |i|
              mb_location[:"tax#{i}"] = BigDecimal.new(mb_location[:"tax#{i}"])
            end

            if (mb_location[:latitude] && mb_location[:longitude])
              mb_location[:latitude] = BigDecimal.new(mb_location[:latitude])
              mb_location[:longitude] = BigDecimal.new(mb_location[:longitude])
            end
          end
      end

      def refresh_staff
        mb_req(
          MindbodyMagic::Models::MB::Staff,
          MindBody::Services::StaffService.get_staff \
            .body.dig(:get_staff_response, :get_staff_result),
          :staff_members
        ) do |mb_staff|
          mb_staff.delete(:provider_i_ds)
        end
      end

      def refresh_class_descriptions
        mb_req(
          MindbodyMagic::Models::MB::MBClassDescription,
          MindBody::Services::ClassService.get_class_descriptions \
            .body.dig(:get_class_descriptions_response, :get_class_descriptions_result),
          :class_descriptions
        ) do |mb_cd|
            mb_cd.delete(:prereq)

            mb_cd[:program_id] = mb_cd.dig(:program, :id)&.to_i
            mb_cd.delete(:program)

            mb_cd[:session_type_id] = mb_cd.dig(:session_type, :id)&.to_i
            mb_cd.delete(:session_type)

            mb_cd[:level_id] = mb_cd.dig(:level, :id)&.to_i
            mb_cd.delete(:level)
          end
      end

      def refresh_class_schedules
        mb_req(
          MindbodyMagic::Models::MB::MBClassSchedule,
          MindBody::Services::ClassService.get_class_schedules \
            .body.dig(:get_class_schedules_response, :get_class_schedules_result),
          :class_schedules
        ) do |mb_cs|
            mb_cs[:location_id] = mb_cs.dig(:location, :id)&.to_i
            mb_cs.delete(:location)

            mb_cs[:class_description_id] = mb_cs.dig(:class_description, :id)&.to_i
            mb_cs.delete(:class_description)

            mb_cs[:staff_id] = mb_cs.dig(:staff, :id)&.to_i
            mb_cs.delete(:staff)

            mb_cs[:semester_id] = mb_cs[:semester_id]&.to_i
          end
      end

      def refresh_classes
        mb_req(
          MindbodyMagic::Models::MB::MBClass,
          MindBody::Services::ClassService
            .get_classes(
               'StartDateTime' => (DateTime.now - 14),
               'EndDateTime' => (DateTime.now + 30),
               'HideCanceledClasses' => true
             )
            .body.dig(:get_classes_response, :get_classes_result),
          :classes
        ) do |mb_class|
            mb_class[:location_id] = mb_class.dig(:location, :id)&.to_i
            mb_class.delete(:location)

            mb_class[:class_description_id] = mb_class.dig(:class_description, :id)&.to_i
            mb_class.delete(:class_description)

            mb_class[:staff_id] = mb_class.dig(:staff, :id)&.to_i
            mb_class.delete(:staff)

            mb_class[:class_schedule_id] = mb_class[:class_schedule_id].to_i

            mb_class[:max_capacity] = mb_class[:max_capacity]&.to_i
            mb_class[:web_capacity] = mb_class[:web_capacity]&.to_i
            mb_class[:web_booked] = mb_class[:web_booked]&.to_i
            mb_class[:total_booked] = mb_class[:total_booked]&.to_i
            mb_class[:total_booked_waitlist] = mb_class[:total_booked_waitlist]&.to_i
          end
      end

      def refresh_clients
        resp = MindBody::Services::ClientService.get_clients

        result = resp.body[:get_clients_response][:get_clients_result]&.deep_symbolize_keys

        if result[:status] != "Success"
          msg = "Failed to get staff response. Error code: " \
                "#{result[:error_code]}, status: '#{result[:status]}'"

          MM_LOGGER.error msg
          raise RuntimeError, msg
        end

        []
      end


      private
      def mb_req(db_model, result, collection_key, &mb_parse)
        result = result.deep_symbolize_keys

        if result[:status] != "Success"
          msg = "Failed to get response. Error code: " \
                "#{result[:error_code]}, status: '#{result[:status]}'"

          MM_LOGGER.error msg
          raise RuntimeError, msg
        end

        mb_items = result[collection_key]
        db_items =
          mb_items.map do |mb_item|
            mb_id = mb_item[:id].to_i

            mb_parsed_hash = mb_item.deep_dup
            mb_parsed_hash[:site_id] = mb_parsed_hash[:site_id].to_i \
              if (mb_parsed_hash.key(:site_id))

            mb_parse&.call(mb_parsed_hash)

            db_item = db_model.first(id: mb_id)
            db_item =
              if db_item.nil?
                MM_LOGGER.info "new #{db_model.name}: ##{mb_id}"
                db_model.create(mb_parsed_hash)
              else
                MM_LOGGER.info "updated #{db_model.name}: ##{mb_id}"

                mb_parsed_hash.reject { |t| t[0] == :id }.each_pair do |key, value|
                  db_item.send("#{key}=", value)
                end

                db_item
              end

            db_item
          end

        db_items.each(&:save)
        db_items
      end

    end
  end
end

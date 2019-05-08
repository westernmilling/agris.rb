# frozen_string_literal: true
module Agris
  module Api
    module Grain
      class Contract
        include XmlModel

        ATTRIBUTE_NAMES = %w(
          contract_location
          contract_number
          date_written
          integration_guid
          purchase_sales
          purchase_sales_description
          contract_location_description
          contract_name_id
          contract_name_description
          contract_type
          unique_id
          contract_type_description
          status
          status_description
          signed
          commodity
          commodity_description
          class
          variety
          transport_mode
          transport_description
          external_contract_no
          delivery_terms
          advance_percent
          contract_loads
          applied_loads
          remaining_loads
          contract_quantity
          applied_quantity
          remaining_quantity
          ordered_quantity
          unordered_quantity
          uom
          uom_description
          dp_table
          dp_table_description
          invoice_terms
          invoice_terms_description
          quantity_base
          quantity_base_description
          weight_base
          weight_base_description
          grade_base
          grade_base_description
          ship_to_from_id
          ship_to_from_description
          misc_id
          misc_description
          agent_broker_id
          agent_broker_description
          qty_uom
          qty_uom_description
          last_change_datetime
          delete
          last_change_user_id
          last_change_username
        ).freeze

        attr_reader(*(%w(schedules) + ATTRIBUTE_NAMES))

        def self.from_xml_hash(hash)
          super.tap do |document|
            if hash['schedules']
              document.schedules.concat(
                [hash['schedules']['schedule']]
                  .flatten
                  .map do |schedule|
                    enhanced_schedule = add_transcodes_to_schedule(schedule)
                    Schedule.from_xml_hash(enhanced_schedule)
                  end
              )
            end
          end
        end

        def self.from_json_hash(hash)
          super.tap do |contract|
            if hash['schedules']
              contract.schedules.concat(
                hash['schedules'].map do |schedule|
                  Schedule.from_json_hash(schedule)
                end
              )
            end
          end
        end

        def initialize(hash = {})
          super

          @schedules = []
        end

        # This adds the transcode attributes like salesperson into the schedule
        def self.add_transcodes_to_schedule(schedule)
          if schedule['trancodes']
            trancodes = schedule['trancodes']['trancode']
            trancodes = [trancodes] unless trancodes.class == Array
            trancodes.each do |trancode|
              label_code = trancode['label'].downcase + 'code'
              schedule[label_code] = trancode['code']
              label_description = trancode['label'].downcase + 'description'
              schedule[label_description] = trancode['description']
            end
          end
          schedule
        end

        class Schedule
          include XmlModel

          ATTRIBUTE_NAMES = %w(
            number
            price_status
            price_status_description
            apply_status
            apply_status_description
            apply_name_id
            apply_name_description
            other_name_id
            other_name_description
            shipper_id
            shipper_description
            delivery_date
            due_date
            pricing_date
            expire_date
            board_name
            futures_month
            spread_from
            spread_type
            spread_type_description
            name_id_type
            name_id_type_description
            scheduled_loads
            applied_loads
            remaining_loads
            scheduled_quantity
            applied_quantity
            remaining_quantity
            settled_quantity
            unsettled_quantity
            ordered_quantity
            unordered_quantity
            contract_price
            futures_price
            basis_price
            freight_price
            brokerage_price
            other_price
            original_schedule_number
            misc_price_1
            misc_price_2
            misc_price_3
            misc_price_4
            misc_price_5
            misc_price_6
            misc_price_7
            misc_price_8
            misc_price_9
            misc_price_10
            misc_price_11
            misc_price_12
            origin_price
            origin_basis
            destination_price
            destination_basis
            inventory_location
            inventory_location_description
            item_number
            item_description
            product_category
            productcategory_description
            state_county
            state_county_description
            defer_canceled_date
            actual_freight_rate
            additional_freight
            pricing_type
            pricing_type_description
            exec_id
            exec_description
            trade_id
            dp_table
            dp_table_description
            schedule_code
            schedule_code_description
            signed
            weight_base
            weight_base_description
            grade_base
            grade_base_description
            ship_to_from_id
            ship_to_from_description
            misc_id
            misc_description
            agent_broker_id
            agent_broker_description
            external_contract_no
            delivery_terms
            advance_percent
            invoice_terms
            invoice_terms_description
            under_fill_tolerance_percent
            over_fill_tolerance_percent
            under_fill_tolerance_units
            over_fill_tolerance_units
            board_description
            price_uom
            price_uom_description
            freight_uom
            freight_uom_description
            price_currency
            price_currency_description
            freight_currency
            freight_currency_description
            basis_uom
            basis_uom_description
            exchange_rate
            exchange_rate_date
            freight_exchange_rate
            freight_exchange_rate_date
            futures_currency
            futures_currency_description
            basis_currency
            basis_currency_description
            basis_exchange_rate
            basis_exchange_rate_date
            futures_exchange_rate
            futures_exchange_rate_date
            futures_uom
            futures_uom_description
            primary_schedule
            option_quantity
            variety
            class
            variety_description
            salesperson_code
            salesperson_description
            merchandiser_code
            merchandiser_description
          ).freeze

          attr_reader(*ATTRIBUTE_NAMES)
        end
      end
    end
  end
end

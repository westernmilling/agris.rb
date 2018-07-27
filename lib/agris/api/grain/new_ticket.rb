# frozen_string_literal: true
module Agris
  module Api
    module Grain
      class NewTicket
        include XmlModel

        ATTRIBUTE_NAMES = %w(
          in_out_code
          ticket_location
          ticket_number
          type
          shipment_date
          entry_date
          ship_to_from_id
          commodity
          variety_class
          storage_bin
          transport_mode
          shipper_id
          vehicle_id
          other_ref
          trancode_4
          trancode_5
          weight_base
          grade_base
          freight_status
          disc_tables
          net_quantity
          gross_weight
          tare_weight
          freight_weight
          freight_rate
          additional_freight
          cash_price
          cash_basis
          gross_date
          gross_time
          gross_entry_method
          tare_date
          tare_time
          tare_entry_method
          driver_id
          car_set_date
          notify_date
          days_allowed
          short_sample_number
          add_update_reverse_option
          adjust_inventory
          freight_tax_percent
          shipment_id
          update_field_selection
          grade_agency_id
          grade_certificate_date
          grade_certificate_number
          weight_agency_id
          weight_certificate_date
          weight_certificate_number
          hauler_id
          weight_uom
          quantity_uom
          freight_currency
          exchange_rate
          exchange_rate_date
          their_invoice_number
          exec_id
          reverse_instruction
          first_4_discount_tables
          sample_number
          last_4_discount_tables
          split_group
          producer_id
          farm
          field
        ).freeze

        attr_reader :record_type
        attr_accessor(*ATTRIBUTE_NAMES)

        def initialize(hash = {})
          super

          @record_type = 'GRNT0'
        end

        def add_application(application)
          @applications ||= []
          @applications << application

          self
        end

        def add_remark(remark)
          @remarks ||= []
          @remarks << remark

          self
        end

        def applications
          @applications || []
        end

        def records
          [self] + applications + remarks
        end

        def remarks
          @remarks || []
        end

        def xml_ignore_attributes
          %i(applications remarks)
        end
      end
    end
  end
end

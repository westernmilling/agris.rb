# frozen_string_literal: true

module Agris
  module Api
    module Grain
      class NewContract
        include XmlModel

        ATTRIBUTE_NAMES = %w(
          purchase_sales
          contract_location
          contract_number
          contract_type
          commodity
          variety
          class
          status
          quantity_base
          weight_base
          grade_base
          signed
          date_written
          contract_name_id
          ship_to_from_id
          misc_id
          agent_broker_id
          external_contract_no
          delivery_terms
          transport_mode
          dp_table
          invoice_terms
          contract_quantity
          contract_loads
          advance_percent
          qty_uom
        ).freeze

        attr_reader :record_type
        attr_accessor(*ATTRIBUTE_NAMES)

        def initialize(hash = {})
          super

          @record_type = 'GRNC0'
        end

        def add_schedule(schedule)
          @schedules ||= []
          @schedules << schedule

          self
        end

        def add_remark(remark)
          @remarks ||= []
          @remarks << remark

          self
        end

        def records
          [self] + schedules + remarks
        end

        def remarks
          @remarks || []
        end

        def xml_ignore_attributes
          %i(schedules remarks)
        end
      end
    end
  end
end

# I.   reserved 1
# V. DISC TABLES
# X. ADD UPDATE OPTION
# Z.   reserved 2
# AD. UPDATE FLD SELECT
# AF. FIRST 20 DISCOUNT TAB
# AG. LAST 20 DISCOUNT TABL
# AH.   reserved 3
# AI.   reserved 4


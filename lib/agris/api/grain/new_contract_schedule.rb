# frozen_string_literal: true
module Agris
  module Api
    module Grain
      class NewContractSchedule
        include XmlModel

        ATTRIBUTE_NAMES = %w(
          price_status
          apply_name_id
          other_name_id
          inventory_location
          item_number
          state_county
          board_name
          futures_month
          spread_from
          spread_type
          delivery_date
          due_date
          pricing_date
          expire_date
          scheduled_quantity
          scheduled_loads
          contract_price
          futures_price
          basis_price
          freight_price
          brokerage_price
          other_price
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
          defer_canceled_date
          pricing_type
          shipper_id
          actual_freight_rate
          additional_freight
          exec_id
          trade_id
          varietyclass
          number
          dp_table
          schedule_code
          weight_base
          grade_base
          signed
          ship_to_from_id
          misc_id
          agent_broker_id
          external_contract_no
          delivery_terms
          invoice_terms
          advance_percent
          under_fill_tolerance_percent
          over_fill_tolerance_percent
          under_fill_tolerance_units
          over_fill_tolerance_units
          price_uom
          freight_uom
          basis_uom
          futures_currency
          futures_exchange_rate
          futures_exchange_rate_date
          basis_currency
          basis_exchange_rate
          basis_exchange_rate_date
          price_currency
          exchange_rate
          exchange_rate_date
          freight_currency
          freight_exchange_rate
          freight_exchange_rate_date
          primary_schedule
          option_quantity
        ).freeze

        attr_accessor(*ATTRIBUTE_NAMES)

        def initialize(hash = {})
          super

          @record_type = 'GRNC1'
        end

        def add_trans_code(trans_code)
          @trans_codes ||= []
          @trans_codes << trans_code

          self
        end

        def trans_codes
          @trans_codes || []
        end

        def records
          [self] + trans_codes
        end

        def xml_ignore_attributes
          %i(trans_codes)
        end
      end
    end
  end
end

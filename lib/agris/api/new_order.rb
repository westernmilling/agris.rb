# frozen_string_literal: true
module Agris
  module Api
    class NewOrder
      include XmlModel

      ATTRIBUTE_NAMES = %w(
        order_location
        order_number
        order_status
        order_type
        line_item_no
        order_date
        shipment_date
        bill_to_from_id
        item_location
        item_number
        item_descr
        price_code
        price_level
        price_schedule
        invoice_terms
        contract_location
        contract_number
        contract_price_schedule
        weight_uom
        quantity_uom
        price_uom
        state
        county
        trancode_1
        trancode_2
        trancode_3
        trancode_4
        trancode_5
        user_order_field_1
        user_order_field_2
        user_line_item_field_1
        external_order_number
        user_line_item_field_1
        exec_id
        ship_to_from_id
        shipper_id
        agent_id
        quantity_ordered
        unit_price
        pre_promo_price
        amount_ordered
        change_type
        cost_proration
        add_update_option
        update_field_selection
        reserved
        last_production_stage
        in_blend
        expiration_date
        item_description
        uniqueid
      ).freeze

      attr_reader :record_type
      attr_accessor(*ATTRIBUTE_NAMES)

      def initialize(hash = {})
        super

        @record_type = "INVP0"
      end

      def add_remark(remark)
        @remarks ||= []
        @remarks << remark

        self
      end

      def remarks
        @remarks || []
      end

      def xml_ignore_attributes
        [:remarks]
      end
    end
  end
end

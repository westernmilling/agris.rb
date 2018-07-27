# frozen_string_literal: true
module Agris
  module Api
    # NB: This is the model for returning orders
    class Order
      include XmlModel

      ATTRIBUTE_NAMES = %w(
        order_location
        order_number
        order_status
        order_type
        order_date
        bill_to_from_id
        delete
        price_code
        price_level
        price_schedule
        invoice_terms
        statecounty
        user_order_field_1
        user_order_field_2
        external_order_number
        ship_to_from_id
        shipper_id
        agent_id
        unique_id
      ).freeze

      attr_reader(*(%w(line_items tran_codes) + ATTRIBUTE_NAMES))

      def self.from_xml_hash(hash)
        super.tap do |order|
          if hash['lineitems']
            order.line_items.concat(
              [hash['lineitems']['lineitem']]
                .flatten
                .map do |lineitem|
                  OrderLine.from_xml_hash(lineitem)
                end
            )
          end
          if hash['trancodes']
            order.tran_codes.concat(
              [hash['trancodes']['trancode']]
              .flatten
              .map do |trancode|
                Agris::Api::TranCode.from_xml_hash(trancode)
              end
            )
          end
        end
      end

      def initialize(hash = {})
        super

        @line_items = []
        @tran_codes = []
      end
    end
  end
end

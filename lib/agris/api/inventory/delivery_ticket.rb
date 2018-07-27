# frozen_string_literal: true
module Agris
  module Api
    module Inventory
      class DeliveryTicket
        include XmlModel

        ATTRIBUTE_NAMES = %w(
          ticket_status
          ticket_status_description
          ticket_location
          ticket_location_description
          ticket_number
          pickup_delivery
          shipment_date
          void_date
          bill_to_id
          bill_to_description
          state_county
          state_county_description
          user_order_field_1
          user_order_field_2
          external_order_number
          ship_to_id
          ship_to_description
          shipper_id
          shipper_description
          broker_id
          broker_description
          invoice_terms
          terms_description
          entry_date
          delete
          last_change_date_time
          last_change_user_id
          last_change_user_name
          unique_id
        ).freeze

        attr_reader(*(%w(line_items remarks tran_codes) + ATTRIBUTE_NAMES))

        def self.from_xml_hash(hash)
          super.tap do |delivery_ticket|
            if hash["lineitems"]
              delivery_ticket.line_items.concat(
                [hash["lineitems"]["lineitem"]]
                .flatten
                .map do |lineitem|
                  DeliveryTicketLineItem.from_xml_hash(lineitem)
                end
              )
            end
            if hash["remarks"]
              delivery_ticket.remarks.concat(
                [hash["remarks"]["remark"]]
                .flatten
                .map do |remark|
                  Agris::Api::Remark.from_xml_hash(remark)
                end
              )
            end
            if hash["trancodes"]
              delivery_ticket.tran_codes.concat(
                [hash["trancodes"]["trancode"]]
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
          @remarks = []
          @tran_codes = []
        end
      end
    end
  end
end

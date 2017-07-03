# frozen_string_literal: true
module Agris
  module Api
    module Inventory
      module Orders
        def create_order(order)
          response = @request.process_message(
            Gyoku.xml(xml: context_hash),
            82_320,
            create_post_payload_xml(convert_order_to_details(order))
          )

          PostResult.new(response)
        end

        def order(order_location, order_number, order_type = 'S')
          extract = SpecificOrderExtract.new(
            order_location, order_number, order_type
          )

          orders([extract])
        end

        def orders(order_extracts)
          extract_documents(
            Messages::QueryOrderDocuments.new(order_extracts),
            Agris::Api::Order
          )
        end

        def orders_changed_since(datetime)
          extract_documents(
            Messages::QueryChangedOrders.new(datetime),
            Agris::Api::Order
          )
        end

        protected

        # NB: We should probably refactor this into a class and write tests
        #     to verify conversion of a sales model to an expected payload.
        def convert_order_to_details(order)
          details = []
          details << order.to_xml_hash
          details << order.remarks.map(&:to_xml_hash)
          details
        end
      end
    end
  end
end

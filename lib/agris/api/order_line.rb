# frozen_string_literal: true
module Agris
  module Api
    # NB: Question, should we split this into a NewOrderLine and reserve this
    #     class for data extracts.
    class OrderLine
      include XmlModel

      ATTRIBUTE_NAMES = %w(
        contract_location
        contract_number
        exec_id
        expiration_date
        line_item_no
        item_location
        item_number
        item_type
        order_status
        price_code
        price_uom
        quantity_ordered
        quantity_shipped
        quantity_uom
        shipment_date
        weight_uom
        unit_price
      ).freeze

      attr_reader(*ATTRIBUTE_NAMES)
    end
  end
end

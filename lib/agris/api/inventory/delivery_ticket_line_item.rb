# frozen_string_literal: true
module Agris
  module Api
    module Inventory
      class DeliveryTicketLineItem
        include XmlModel

        ATTRIBUTE_NAMES = %w(
          line_item_number
          activity_location
          activity_location_description
          inventory_location
          inventory_location_description
          inventory_item
          inventory_item_description
          sub_item_1
          sub_item_1_description
          sub_item_2
          product_category
          category_description
          individual_charge_id
          individual_charge_description
          order_location
          order_location_description
          order_number
          weight_uom
          weight_uom_description
          quantity_uom
          quantity_uom_description
          price_uom
          price_uom_description
          other_reference
          execution_id
          execution_id_description
          quantity
          unit_price
          total_price
          unit_cost
          total_cost
          gross_weight
          tare_weight
          net_weight
          invoice_number
          invoice_location
          invoice_location_description
          in_blend
          blend_number
          formula_no
          source_type
          restricted_product
          change_type
          change_type_description
        ).freeze

        attr_reader(*ATTRIBUTE_NAMES)
      end
    end
  end
end

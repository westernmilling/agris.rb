# frozen_string_literal: true
module Agris
  module Api
    module Inventory
      class SpecificOrderExtract
        include ::Agris::XmlModel

        attr_accessor :order_location, :order_number, :order_type

        def initialize(order_location, order_number, order_type)
          @order_location = order_location
          @order_number = order_number
          @order_type = order_type
        end
      end
    end
  end
end

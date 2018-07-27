# frozen_string_literal: true
module Agris
  module Api
    class NewOrderRemark
      include XmlModel

      ATTRIBUTE_NAMES = %w(
        number
        order_line
        value
      ).freeze

      attr_reader :record_type

      def initialize(hash = {})
        super

        @record_type = "INVP3"
      end
    end
  end
end

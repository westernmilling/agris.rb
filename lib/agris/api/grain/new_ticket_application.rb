# frozen_string_literal: true
module Agris
  module Api
    module Grain
      class NewTicketApplication
        include XmlModel

        ATTRIBUTE_NAMES = %w(
          apply_type
          expected_apply_type
          apply_name_id
          apply_location
          apply_reference
          apply_reference_pricing
          gross_quantity
          net_quantity
          position_quantity
          apply_date
          contract_variety_class
          recalculate_discounts
        ).freeze

        attr_reader :record_type
        attr_accessor(*ATTRIBUTE_NAMES)

        def initialize(hash = {})
          super

          @record_type = 'GRNT1'
        end
      end
    end
  end
end

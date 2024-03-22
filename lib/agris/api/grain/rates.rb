# frozen_string_literal: true

module Agris
  module Api
    module Grain
      class Rates
        include XmlModel

        ATTRIBUTE_NAMES = %w(
          rate_1
          rate_2
          rate_3
          rate_4
          rate_type_1
          rate_type_2
          rate_type_3
          rate_type_4
          code_1
          code_2
          code_3
          code_4
          table_1
          table_2
          table_3
          table_4
        ).freeze

        attr_reader :record_type
        attr_accessor(*ATTRIBUTE_NAMES)

        def initialize(hash = {})
          super

          @record_type = 'GRNT1R'
        end
      end
    end
  end
end

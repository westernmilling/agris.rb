# frozen_string_literal: true
module Agris
  module Api
    module Grain
      class NewContractScheduleTranscode
        include XmlModel

        ATTRIBUTE_NAMES = %w(
          number
          code
          description
        ).freeze

        attr_reader :record_type

        def initialize(hash = {})
          super

          @record_type = 'GRNC2'
        end
      end
    end
  end
end

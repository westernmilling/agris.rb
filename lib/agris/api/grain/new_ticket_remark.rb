# frozen_string_literal: true
module Agris
  module Api
    module Grain
      class NewTicketRemark
        include XmlModel

        ATTRIBUTE_NAMES = %w(
          number
          value
        ).freeze

        attr_reader :record_type

        def initialize(hash = {})
          super

          @record_type = "GRNT2"
        end
      end
    end
  end
end

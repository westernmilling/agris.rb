# frozen_string_literal: true

module Agris
  module Api
    module Name
      class NewFarmField
        include XmlModel

        ATTRIBUTE_NAMES = %w(
          name_id
          farm_abbreviation
          farm_status
          farm_description
          field_abbreviation
          field_status
          field_description
        ).freeze

        attr_accessor(*ATTRIBUTE_NAMES)

        def initialize(hash = {})
          super

          @record_type = 'NAMF0'
        end
      end
    end
  end
end

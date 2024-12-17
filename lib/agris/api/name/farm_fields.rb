# frozen_string_literal: true
module Agris
  module Api
    module Name
      class FarmFields
        include XmlModel

        ATTRIBUTE_NAMES = %w(
          guid
          nameid
          farmdescription
          status
          abbreviation
          fielddescription
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

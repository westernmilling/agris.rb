# frozen_string_literal: true
module Agris
  module Api
    module Messages
      class Import < MessageBase
        def initialize(model)
          @model = model
        end

        def message_number
          82_320
        end

        def message_hash
          {
            xml: xml_hash
          }
        end

        protected

        def input_hash
          {
            :@endofprocessoption => 1,
            :@altnameidonfile => 'N',
            :@usecurdate4outofrange => 'N',
            :@reportoption => 1,
            :@usefile => false
          }
        end

        def xml_hash
          xml_base_hash.merge(
            details: { detail: @model.records.map(&:to_xml_hash) }
          )
        end
      end
    end
  end
end

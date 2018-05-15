# frozen_string_literal: true
module Agris
  module Api
    module Messages
      class QueryCommodityCodeDocuments < QueryBase
        def initialize(document_references)
          @document_references = document_references
        end

        def message_number
          81_300
        end

        protected

        def input_hash
          input_base_hash
        end

        def xml_hash
          xml_base_hash
            .merge(
              commodity: @document_references.map(&:to_xml_hash)
            )
        end
      end
    end
  end
end

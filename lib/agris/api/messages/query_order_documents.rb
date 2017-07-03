# frozen_string_literal: true
module Agris
  module Api
    module Messages
      class QueryOrderDocuments < QueryBase
        def initialize(document_references)
          @document_references = document_references
        end

        def message_number
          80_900
        end

        protected

        def input_hash
          input_base_hash
        end

        def xml_hash
          xml_base_hash
            .merge(
              order: @document_references.map(&:to_xml_hash),
              lineitemdetail: true,
              componentdetail: true,
              remarkdetail: true,
              lineremarkdetail: true,
              trancodedetail: true,
              specificationdetail: true
            )
        end
      end
    end
  end
end

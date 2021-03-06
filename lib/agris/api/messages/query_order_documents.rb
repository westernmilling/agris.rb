# frozen_string_literal: true
module Agris
  module Api
    module Messages
      class QueryOrderDocuments < DocumentQueryBase
        def message_number
          80_900
        end

        protected

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

# frozen_string_literal: true
module Agris
  module Api
    module Messages
      class QueryInvoiceDocuments < QueryBase
        def initialize(document_references)
          @document_references = document_references
        end

        def message_number
          80_500
        end

        protected

        def input_hash
          input_base_hash
        end

        def xml_hash
          xml_base_hash
            .merge(
              invoice: @document_references.map(&:to_xml_hash),
              componentdetail: true,
              discountdetail: true,
              gldistributiondetail: true,
              lineitemdetail: true,
              lineremarkdetail: true,
              remarkdetail: true,
              specificationdetail: true,
              splitdetail: true,
              taxdetail: true,
              taxratedetail: true,
              trancodedetail: true
            )
        end
      end
    end
  end
end

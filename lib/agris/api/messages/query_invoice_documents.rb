# frozen_string_literal: true
module Agris
  module Api
    module Messages
      class QueryInvoiceDocuments < DocumentQueryBase
        def message_number
          80_500
        end

        protected

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

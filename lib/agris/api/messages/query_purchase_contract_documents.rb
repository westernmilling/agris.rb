# frozen_string_literal: true
module Agris
  module Api
    module Messages
      class QueryPurchaseContractDocuments < DocumentQueryBase
        def message_number
          80_150
        end

        protected

        def xml_hash
          xml_base_hash
            .merge(
              contract: @document_references.map(&:to_xml_hash)
            )
        end
      end
    end
  end
end

# frozen_string_literal: true
module Agris
  module Api
    module Messages
      class QueryCommodityCodeDocuments < DocumentQueryBase
        def message_number
          81_300
        end

        protected

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

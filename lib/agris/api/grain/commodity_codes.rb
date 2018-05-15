# frozen_string_literal: true
module Agris
  module Api
    module Grain
      module CommodityCodes
        def commodity_code(location, code)
          extract = Agris::Api::Grain::SpecificCommodityCodeExtract
                    .new(location, code)

          commodity_codes([extract])
        end

        def commodity_codes(extracts)
          extract_documents(
            Messages::QueryCommodityCodeDocuments.new(extracts),
            Agris::Api::Grain::Commodity
          )
        end
      end
    end
  end
end

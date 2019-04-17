# frozen_string_literal: true
module Agris
  module Api
    module Grain
      module SalesContracts
        def sales_contract(contract_location, contract_number)
          extract = Agris::Api::Grain::SpecificContractExtract
                    .new(contract_location, contract_number)

          sales_contracts([extract])
        end

        def sales_contracts(extracts)
          extract_documents(
            Messages::QuerySalesContractDocuments.new(extracts),
            Agris::Api::Grain::Contract
          )
        end

        def sales_contracts_changed_since(datetime, detail = false)
          extract_documents(
            Messages::QueryChangedSalesContracts.new(datetime, detail),
            Agris::Api::Grain::Contract
          )
        end
      end
    end
  end
end

# frozen_string_literal: true
module Agris
  module Api
    module Grain
      module PurchaseContracts
        def purchase_contract(contract_location, contract_number)
          extract = Agris::Api::Grain::SpecificPurchaseContractExtract
                    .new(contract_location, contract_number)

          purchase_contracts([extract])
        end

        def purchase_contracts(extracts)
          extract_documents(
            Messages::QueryPurchaseContractDocuments.new(extracts),
            Agris::Api::Grain::Contract
          )
        end

        def purchase_contracts_changed_since(datetime, detail = false)
          extract_documents(
            Messages::QueryChangedPurchaseContracts.new(datetime, detail),
            Agris::Api::Grain::Contract
          )
        end

        def grain_setup
          grain = extract_documents(
            Messages::QueryGrainSetup.new,
            Agris::Api::Grain::GrainSetup
          )

          byebug
        end
      end
    end
  end
end

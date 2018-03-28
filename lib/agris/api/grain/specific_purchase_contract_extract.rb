# frozen_string_literal: true
module Agris
  module Api
    module Grain
      class SpecificPurchaseContractExtract
        include ::Agris::XmlModel

        attr_accessor :contract_location, :contract_number

        def initialize(contract_location, contract_number)
          @contract_location = contract_location
          @contract_number = contract_number
        end
      end
    end
  end
end

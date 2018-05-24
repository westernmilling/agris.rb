# frozen_string_literal: true
module Agris
  module Api
    module Messages
      class QueryChangedPurchaseContracts < ChangedQueryBase
        def message_number
          80_150
        end

        protected

        def xml_hash
          xml_base_hash
        end
      end
    end
  end
end

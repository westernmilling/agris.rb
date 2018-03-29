# frozen_string_literal: true
module Agris
  module Api
    module Messages
      class QueryChangedPurchaseContracts < QueryBase
        def initialize(time, detail)
          @time = time
          @detail = detail
        end

        def message_number
          80_150
        end

        protected

        def input_hash
          input_base_hash
            .merge(
              :@details => @detail,
              locid: {
                :@datetime => @time.strftime('%Y-%m-%dT%H:%M:%S'),
                :@id => nil,
                :@loccode => nil
              }
            )
        end

        def xml_hash
          xml_base_hash
        end
      end
    end
  end
end

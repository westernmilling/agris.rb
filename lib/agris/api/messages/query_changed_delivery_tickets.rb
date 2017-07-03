# frozen_string_literal: true
module Agris
  module Api
    module Messages
      class QueryChangedDeliveryTickets < QueryBase
        def initialize(time)
          @time = time
        end

        def message_number
          80_600
        end

        protected

        def input_hash
          input_base_hash
            .merge(
              locid: {
                :@datetime => @time.strftime('%Y-%m-%dT%H:%M:%S'),
                :@id => nil,
                :@loccode => nil
              }
            )
        end

        def xml_hash
          xml_base_hash
            .merge(
              lineitemdetail: true,
              componentdetail: true,
              remarkdetail: true,
              lineremarkdetail: true,
              trancodedetail: true,
              specificationdetail: true
            )
        end
      end
    end
  end
end
